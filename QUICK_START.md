# G-Market Villa - Quick Start Guide

## Live Demo
**Try it now:** https://hcai47q57myqk.ok.kimi.link

---

## Build Options (Choose One)

### Option 1: GitHub Actions (Easiest - 5 minutes)

1. Create a new GitHub repository
2. Upload all files from `gmarket-villa-app` folder
3. Go to **Actions** tab → Select **Build Android APK**
4. Click **Run workflow**
5. Download your APK from the Artifacts section

### Option 2: Docker (10 minutes)

```bash
cd gmarket-villa-app
docker-compose up --build
# APK will be in output/G-Market-Villa.apk
```

### Option 3: Android Studio (15 minutes)

1. Download and install [Android Studio](https://developer.android.com/studio)
2. Open the `android` folder in Android Studio
3. Wait for Gradle sync (first time only)
4. Click **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
5. Find APK at: `android/app/build/outputs/apk/debug/app-debug.apk`

### Option 4: Online Build Service

Use these free services:
- **Bitrise.io** - Connect GitHub repo, automatic builds
- **Codemagic.io** - CI/CD for mobile apps
- **AppCircle.io** - Mobile DevOps platform

---

## Project Files

| File | Description |
|------|-------------|
| `gmarket-villa-app.tar.gz` | Complete project archive |
| `www/index.html` | Main web app (works standalone) |
| `android/` | Android native project |
| `BUILD_GUIDE.md` | Detailed build instructions |
| `BUILD_ALL.sh` | Build script for Linux/Mac |
| `Dockerfile` | Docker build configuration |
| `docker-compose.yml` | Docker Compose setup |
| `.github/workflows/` | GitHub Actions CI/CD |

---

## Default Login Credentials

| Role | Username | Password |
|------|----------|----------|
| Buyer | buyer@demo.com | pass |
| Partner | partner@demo.com | pass |
| Admin | admin | admin123 |

---

## App Features

### For Buyers
- Browse products by category
- Search and filter
- Add to cart & wishlist
- Product reviews
- View partner profiles

### For Partners
- List products with photos
- Set delivery options
- Track earnings
- Withdraw to bank
- Manage orders

### For Admins
- Platform profit tracking
- User management
- Post announcements

---

## Need Help?

**WhatsApp:** +234 901 440 6974

**Build Issues?**
- Check `BUILD_GUIDE.md` for detailed troubleshooting
- Try the web version first: https://hcai47q57myqk.ok.kimi.link
- Use GitHub Actions for easiest build experience

---

## App Information

- **App ID:** com.gmarketvilla.app
- **App Name:** G-Market Villa
- **Version:** 1.0.0
- **Min Android:** 5.1 (API 22)
- **Target Android:** 14 (API 34)

---

## License

© 2024 G-Market Villa. All rights reserved.
