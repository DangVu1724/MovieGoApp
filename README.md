# 🎬 MovieGo - Ứng dụng Đặt Vé Xem Phim  

## 📖 Giới thiệu  
MovieGo là một ứng dụng đặt vé xem phim giúp người dùng dễ dàng:  
- Tra cứu lịch chiếu, rạp chiếu.  
- Chọn ghế và đặt vé trực tuyến.  
- Thanh toán qua nhiều phương thức (ví điện tử, thẻ ngân hàng).  
- Lưu vé điện tử và quét mã khi vào rạp.  

Ứng dụng được xây dựng bằng **Flutter** và sử dụng **Firebase** làm backend.  

---

## 🖌️ Thiết kế giao diện ứng dụng MovieGo

Link: https://www.figma.com/design/NqcOSgi8HWGjuI2IuL6NdW/MovieGo?node-id=0-1&t=U9gsXHalg0XNwFlZ-1

---

## ⚡ Yêu cầu chức năng  
✔ **Đăng ký / Đăng nhập** (Email/Google).  
✔ **Tìm kiếm phim & lịch chiếu**.  
✔ **Đặt vé & chọn ghế**.  
✔ **Thanh toán vé (Momo, Visa, MasterCard)**.  
✔ **Lưu vé điện tử & hiển thị mã QR**.  
✔ **Quản lý lịch sử đặt vé**.  

---

## 🛠️ Yêu cầu phi chức năng  
✔ **Giao diện thân thiện & dễ sử dụng**.  
✔ **Bảo mật dữ liệu người dùng**.  
✔ **Hỗ trợ đa nền tảng (Android, iOS)**.  
✔ **Thời gian phản hồi nhanh (< 3s)**.  

---

## 🔥 Cài đặt & Chạy dự án  
### **1️⃣ Clone dự án từ GitHub**  
```sh
git clone https://github.com/nguyennam5724/PT-TKPM.git
cd moviego
```

### **2️⃣ Cài đặt các dependencies**  
```sh
flutter pub get
```

### **3️⃣ Chạy ứng dụng trên thiết bị giả lập hoặc điện thoại**  
```sh
flutter run
```

---

## 🔥 Thiết lập Firebase  
MovieGo sử dụng **Firebase** để xác thực & lưu trữ dữ liệu.  

### **1️⃣ Tạo Firebase Project**
1. Truy cập [Firebase Console](https://console.firebase.google.com/).  
2. **Tạo một dự án Firebase mới** với tên tùy chọn.  
3. Chọn **Thêm ứng dụng Android**.  
4. **Nhập Android package name**:  
   - Mở file `android/app/build.gradle` và lấy giá trị `namespace`, ví dụ:  
   ```gradle
   namespace "com.example.moviego"
   ```
   - Dán giá trị này vào **Android package name** khi đăng ký Firebase.  
5. Đặt **App nickname** (tùy chọn), sau đó ấn **Next**.  

---

### **2️⃣ Cấu hình Firebase vào ứng dụng Flutter**
1. **Tải file `google-services.json` về** từ Firebase Console.  
2. **Di chuyển file `google-services.json` vào thư mục**:  
   ```
   android/app/
   ```
3. Mở `android/build.gradle` và đảm bảo có dòng sau:  
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.10'
   }
   ```

4. Mở `android/app/build.gradle`, thêm dòng này cuối file:  
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

---

### **3️⃣ Thiết lập Firebase Authentication**
1. Truy cập **Firebase Console > Authentication**.  
2. Chọn **Sign-in method** và bật các phương thức:  
   - **Email/Password**  
   - **Google**  

---

### **4️⃣ Thiết lập Firestore Database**
1. Truy cập **Firebase Console > Firestore Database**.  
2. Bấm **Create Database** → Chọn **Start in test mode**.  
3. Trong **Rules**, cập nhật quyền truy cập tạm thời:  
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```
4. Tạo các **Collections chính**:  
   ```
   users (Lưu thông tin người dùng)
   ├── tickets (Lưu vé đã đặt)
   cinemas (Lưu danh sách rạp chiếu)
   ```
---

## 📂 Cấu trúc thư mục  
```sh
moviego/
│── android/                 # Cấu hình Android
│── ios/                     # Cấu hình iOS
│── lib/                     # Code chính của Flutter
│   ├── controllers/         # Logic & xử lý dữ liệu
│   ├── models/              # Định nghĩa các model dữ liệu
│   ├── screens/             # Màn hình UI
│   ├── widgets/             # Các widget dùng chung
│   ├── services/            # Kết nối Firebase & API
│   ├── pages/               # Giao diện đăng nhập/đăng ký
│   ├── CustomUI/            
│   ├── ForgotPassWord/
│   ├── LoginWithGoogle/
│   ├── auth/                # Xác thực tài khoản
│   ├── firebase_options.dart
│   ├── main.dart            # Điểm bắt đầu của ứng dụng
│── assets/                  # Hình ảnh & fonts
│── pubspec.yaml             # Danh sách dependencies
│── README.md                # Tài liệu dự án
```

---

## 🏆 Kết luận  
🎬 **MovieGo** giúp bạn đặt vé xem phim dễ dàng, nhanh chóng!  
🚀 Cài đặt Firebase, đăng nhập Google & Email, và **chạy ngay chỉ với vài bước**.  
💡 Nếu có vấn đề, hãy mở **issue trên GitHub** hoặc liên hệ nhóm phát triển.  

📌 **Chúc bạn có trải nghiệm đặt vé tuyệt vời!** 🎟️🎞️  
