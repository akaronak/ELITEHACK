# Medical Report OCR Feature - Enhanced with PDF & Camera Support

## Overview
The medical report OCR feature has been enhanced to support:
- 📸 **Camera photos** - Take photos directly from the device camera
- 🖼️ **Gallery images** - Upload images from device gallery
- 📄 **PDF files** - Upload and analyze PDF medical reports

## Changes Made

### Frontend (Flutter)

#### 1. **Profile Screen** (`mensa/lib/screens/profile_screen.dart`)
- Updated `_uploadMedicalReport()` to show a dialog with three options:
  - Take Photo (camera)
  - Choose Image (gallery)
  - Upload PDF
- Added `_pickAndAnalyzeReport()` method to handle image uploads from camera/gallery
- Added `_pickAndAnalyzePDF()` method to handle PDF file uploads
- Both methods send files to backend for analysis

#### 2. **API Service** (`mensa/lib/services/api_service.dart`)
- Added `file_picker` package import
- Updated `analyzeMedicalReport()` to accept `fileType` parameter ('image' or 'pdf')
- Added `pickPDFFile()` method to handle PDF file selection using FilePicker

#### 3. **Dependencies** (`mensa/pubspec.yaml`)
- Added `file_picker: ^6.1.1` for PDF and file selection

### Backend (Node.js)

#### 1. **OCR Routes** (`server/src/routes/ocr.routes.js`)
- Updated `/analyze-report` endpoint to accept `fileType` parameter
- Supports both 'image' and 'pdf' MIME types
- Updated prompt to handle both image and PDF documents

#### 2. **Gemini Service** (`server/src/services/geminiService.js`)
- Added `analyzeDocument()` method that accepts:
  - `base64Data` - Base64 encoded file content
  - `prompt` - Analysis prompt
  - `mimeType` - MIME type ('image/jpeg' or 'application/pdf')
- Supports Gemini's vision capabilities for both images and PDFs

## How It Works

### User Flow
1. User clicks "Upload Report Image" button in profile
2. Dialog appears with three options
3. User selects:
   - **Take Photo**: Opens camera to capture medical report
   - **Choose Image**: Opens gallery to select existing image
   - **Upload PDF**: Opens file picker to select PDF file
4. File is converted to base64 and sent to backend
5. Gemini AI analyzes the document
6. Results displayed with:
   - Easy-to-understand summary
   - Key findings (bullet points)
   - Recommendations (bullet points)

### Technical Flow
```
User selects file
    ↓
Frontend converts to base64
    ↓
Sends to /api/ocr/analyze-report
    ↓
Backend receives base64 + fileType
    ↓
Gemini analyzes with appropriate MIME type
    ↓
Returns JSON with summary, findings, recommendations
    ↓
Frontend displays results in formatted card
```

## Installation

### For Users
1. Run `flutter pub get` to install new dependencies
2. No additional configuration needed

### For Developers
The feature is production-ready. Ensure:
- `GEMINI_API_KEY` is set in `.env` file
- Backend server is running with OCR routes registered
- File picker permissions are configured in Android/iOS manifests

## Supported File Types

| Type | Format | Max Size | MIME Type |
|------|--------|----------|-----------|
| Image | JPG, PNG | 85% quality | image/jpeg |
| PDF | PDF | No limit | application/pdf |

## Error Handling

- **No file selected**: Dialog closes, no action taken
- **File too large**: Handled by file picker
- **Analysis failed**: User sees error message with retry option
- **Invalid file**: Gemini returns error in response

## Future Enhancements

- Add image compression for large files
- Support for multiple file uploads
- Save analysis history
- Export analysis as PDF
- Support for more document types (DOCX, images with text)

## Testing

To test the feature:
1. Go to Profile screen
2. Scroll to "Medical Report Analysis" section
3. Click "Upload Report Image"
4. Select one of three options
5. Choose a medical report (image or PDF)
6. Wait for analysis
7. View results

## Notes

- Camera permission required on Android/iOS
- File picker permission required on Android/iOS
- Gemini API must be initialized with valid API key
- PDF analysis may take slightly longer than image analysis
