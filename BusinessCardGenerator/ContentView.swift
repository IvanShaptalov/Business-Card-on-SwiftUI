import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
struct ContentView: View {
    
    @State private var url = "https://realestatewithshayaan.com"
    
    @MainActor func imageToShare() -> UIImage?{
        return UIImage(data: generateQRCodeWithLogo(websiteLink: url, name: "Shayaan Siddiqui", email: "ssiddiqui@nexthomerepros.com", phone: "609.255-9635")!)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your link", text: $url)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Image(uiImage: imageToShare()!)
                    .resizable()
                    .frame(width: 300, height: 450)
                
                Button(action: shareImage) {
                            Text("Share Image")
                        }
                
            }
            .navigationTitle("Business Card")
        }
    }
    
    @MainActor func shareImage() {
            guard let image = imageToShare() else {
                print("Image not found")
                return
            }
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    
    @MainActor
    func generateQRCodeWithLogo(websiteLink: String, name: String, email: String, phone: String) -> Data? {
        // Create QR code
        let filter = CIFilter.qrCodeGenerator()
        guard let data = websiteLink.data(using: .ascii, allowLossyConversion: false) else { return nil }
        filter.message = data
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 12, y: 12)
        let scaledCIImage = ciimage.transformed(by: transform)
        let qrCodeImage = UIImage(ciImage: scaledCIImage)
        
        // Load custom logo
        let logoImage = Image("NextHomeLogo")
        let logoSize = CGSize(width: 100, height: 100)
        guard let uiLogoImage = logoImage.getUIImage(newSize: logoSize) else {
            return nil
        }
        
        // Text attributes
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.orange
        ]
        
        let blackTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        
        // Calculate total height of logo and text
        let totalHeight = uiLogoImage.size.height + 100 // 100 is an arbitrary value, adjust as needed
        
        // Draw text
        let imageSize = CGSize(width: max(uiLogoImage.size.width, qrCodeImage.size.width), height: totalHeight + qrCodeImage.size.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        // Draw logo
        uiLogoImage.draw(at: CGPoint(x: (imageSize.width - uiLogoImage.size.width) / 2, y: 0))
        
        // Draw name
        let nameText = NSAttributedString(string: name, attributes: textAttributes)
        nameText.draw(at: CGPoint(x: (imageSize.width - nameText.size().width) / 2, y: uiLogoImage.size.height))
        
        // Draw phone
        let phoneText = NSAttributedString(string: phone, attributes: blackTextAttributes)
        phoneText.draw(at: CGPoint(x: (imageSize.width - phoneText.size().width) / 2, y: uiLogoImage.size.height + 25)) // Adjust the y position as needed
        
        // Draw email
        let emailText = NSAttributedString(string: email, attributes: blackTextAttributes)
        emailText.draw(at: CGPoint(x: (imageSize.width - emailText.size().width) / 2, y: uiLogoImage.size.height + 50)) // Adjust the y position as needed
        
        // Draw QR code
        qrCodeImage.draw(at: CGPoint(x: (imageSize.width - qrCodeImage.size.width) / 2, y: totalHeight)) // Adjust the y position as needed
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage?.pngData()
    }
}


extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}
