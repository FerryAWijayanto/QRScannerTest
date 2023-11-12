//
//  QRScannerViewController.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit
import AVFoundation
import Combine

class QRScannerViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!

    private let captureSession: AVCaptureSession = .init()
    private let metadataOutput: AVCaptureMetadataOutput = .init()

    private var captureDevice: AVCaptureDevice?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    var vwQRCode: UIView?

    private let viewModel: ScannerViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ScannerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVideoCapture()
        addVideoPreviewLayer()
        initializeQRView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async { self.captureSession.startRunning() }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCameraSession()
    }

    private func bindViewModel() {
        viewModel.eventMerchantInfo
            .sink { [weak self] input in
                self?.navigateToPayment(input: input)
            }.store(in: &cancellables)
    }

    private func navigateToPayment(input: PaymentViewModel.Input) {
        let vc = ViewControllerFactory.createPaymentViewController(input: input)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func stopCameraSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    private func configureVideoCapture() {
        guard let device: AVCaptureDevice = .default(.builtInWideAngleCamera, for: .video, position: .back),
              let captureDeviceInput = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(captureDeviceInput),
              captureSession.canAddOutput(metadataOutput) else {
            return
        }

        do {
            try device.lockForConfiguration()
            device.focusMode = .continuousAutoFocus
            device.exposureMode = .continuousAutoExposure
            device.unlockForConfiguration()
        } catch {
            print(error)
        }

        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.qr]
    }

    private func addVideoPreviewLayer() {
        let cameraPreviewLayer: AVCaptureVideoPreviewLayer = .init(session: captureSession)
        cameraView.layer.addSublayer(cameraPreviewLayer)
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.frame = UIScreen.main.bounds
        self.cameraPreviewLayer = cameraPreviewLayer

        DispatchQueue.global(qos: .background).async { self.captureSession.startRunning() }
    }

    private func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.red.cgColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubviewToFront(vwQRCode!)
    }

}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            vwQRCode?.frame = CGRectZero
            print("NO QRCode text detacted")
            return
        }

        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let objBarCode = cameraPreviewLayer?.transformedMetadataObject(for: readableObject),
              let stringValue = readableObject.stringValue else {
            return
        }
        vwQRCode?.frame = objBarCode.bounds

        viewModel.getQRMerchantInfo(value: stringValue)
    }
}
