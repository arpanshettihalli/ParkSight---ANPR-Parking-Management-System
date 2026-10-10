# ParkSight — ANPR Parking Management System

**An intelligent parking management system using Automatic Number Plate Recognition (ANPR) to automate vehicle entry, exit tracking, parking sessions, and billing.**

ParkSight is a computer vision and backend engineering project that combines license plate detection, OCR, and a REST API to simplify parking management. The goal is to build a system that can identify vehicles, maintain parking records, calculate parking fees, and maintain an auditable history of operations.

## 🚀 Features

- **License Plate Detection:** YOLO-based detection of Indian vehicle license plates.
- **Optical Character Recognition (OCR):** Custom PyTorch-based CNN–BiLSTM model trained using Connectionist Temporal Classification (CTC) loss.
- **REST API:** Ruby on Rails API for receiving plate detection results.
- **Vehicle Management:** Store and retrieve vehicle records using license plate numbers.
- **Parking Session Management:** Track vehicle entry and exit events.
- **Automated Billing:** Calculate parking fees based on session duration.
- **Asynchronous Processing:** Use Active Job and Solid Queue to process detection requests in the background.
- **Audit Logging:** Record vehicle entry, exit, and detection-related events for traceability.
- **PostgreSQL Database:** Persist vehicle, parking session, detection, and audit information.

## 🏗️ System Architecture

```text
Camera / Vehicle Image
         |
         v
 YOLO Plate Detection
         |
         v
     Plate Crop
         |
         v
 PyTorch OCR Model
         |
         v
 Plate Number + Confidence
         |
         v
    Rails REST API
         |
         v
    Active Job Queue
         |
         v
 Parking Processing Service
         |
         +------> Vehicle Records
         |
         +------> Parking Sessions
         |
         +------> Detection Records
         |
         +------> Audit Logs
         |
         v
   Parking Fee Calculation
```

The computer vision pipeline and Rails backend are developed as separate components, with the backend currently accepting plate numbers and confidence scores through its API.

## 🧠 Machine Learning Models

### 1. License Plate Detection

A YOLO-based detector trained to locate Indian vehicle license plates in images.

| Metric     | Result |
| ---------- | -----: |
| Precision  | 97.52% |
| Recall     | 81.18% |
| mAP\@50    | 94.09% |
| mAP\@50–95 | 77.57% |

### 2. License Plate OCR

A custom PyTorch OCR model using a residual CNN, bidirectional LSTM layers, and CTC-based sequence prediction.

The model is trained to recognize uppercase letters and digits from cropped license plate images.

| Metric                     | Validation result |
| -------------------------- | ----------------: |
| Character Error Rate (CER) |            20.05% |
| Exact-match accuracy       |            33.73% |

*These are experimental validation results, not production performance guarantees. Improving OCR accuracy and evaluating performance under varying lighting, blur, and viewing angles remain important next steps.*

## 🛠️ Tech Stack

**Machine Learning**

- Python
- PyTorch
- YOLO
- OpenCV

**Backend**

- Ruby on Rails 8
- REST APIs
- Active Job
- Solid Queue

**Database**

- PostgreSQL
- Active Record ORM

**Development Tools**

- Git and GitHub
- VS Code
- Kaggle Notebooks

## 📂 Project Structure

```text
parking_anpr/
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           └── detections_controller.rb
│   ├── jobs/
│   │   └── process_detection_job.rb
│   ├── models/
│   │   ├── vehicle.rb
│   │   ├── parking_session.rb
│   │   ├── detection.rb
│   │   └── audit_log.rb
│   └── services/
│       └── parking/
│           └── process_detection.rb
├── config/
│   ├── database.yml
│   └── queue.yml
├── db/
│   ├── migrate/
│   └── queue_schema.rb
├── Gemfile
└── README.md
```

*The machine learning models and training notebooks are maintained separately from the Rails application.*

## ⚙️ Getting Started

### Prerequisites

- Ruby compatible with the project's Gemfile
- Rails
- PostgreSQL
- Bundler
- Python and PyTorch for the separate ML pipeline

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/parksight-anpr-parking-system.git
cd parksight-anpr-parking-system
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Configure PostgreSQL

Update `config/database.yml` with your local PostgreSQL connection details. Keep database credentials out of version control.

### 4. Prepare the database

```bash
bin/rails db:prepare
```

### 5. Start the Rails server

```bash
bin/rails server
```

The API will be available at:

```text
http://localhost:3000
```

**Background worker:** Solid Queue is configured for asynchronous job processing. Worker startup is still being validated in the native Windows environment; use a compatible worker environment until that setup is resolved.

## 🔌 API Usage

### Submit a plate detection

**Endpoint**

```http
POST /api/v1/detections
Content-Type: application/json
```

**Request body**

```json
{
  "plate_number": "KA05AB1234",
  "confidence": 0.94
}
```

**Expected response**

```json
{
  "message": "Detection queued",
  "plate_number": "KA05AB1234"
}
```

The API acknowledges the queued request. The actual database processing occurs asynchronously when the worker is running.

## 💰 Parking Billing

The current demonstration billing logic charges ₹20 per started hour, with a minimum charge of ₹20.

For example:

| Parking duration  | Fee |
| ----------------- | --: |
| 20 minutes        | ₹20 |
| 1 hour            | ₹20 |
| 1 hour 20 minutes | ₹40 |
| 3 hours           | ₹60 |

This is a basic billing rule intended for development and can be extended to support configurable rates, grace periods, and other pricing policies.

## 🔐 Reliability and Engineering Goals

The project is being developed with real-world backend concerns in mind:

- Background job processing and retry policies.
- Database consistency and reliable parking session transitions.
- Audit trails for investigating failed operations.
- Duplicate detection handling and idempotency.
- API validation and error handling.
- Integration of trained ML models with the backend.
- Deployment and monitoring.

Some of these capabilities are still under development. In particular, camera-level deduplication, concurrent requests, and entry-versus-exit direction handling need additional safeguards before real parking-gate deployment.

## 🗺️ Roadmap

- [x] Train a YOLO-based license plate detector.
- [x] Train a custom PyTorch OCR model.
- [x] Build a Rails REST API for detection results.
- [x] Implement vehicle and parking session records.
- [x] Add parking fee calculation and audit logging.
- [ ] Complete reliable background job retries and failure handling.
- [ ] Integrate the trained detection and OCR models with the backend.
- [ ] Add robust duplicate detection and idempotent processing.
- [ ] Build a parking operator dashboard.
- [ ] Add authentication and role-based authorization.
- [ ] Deploy the application and evaluate end-to-end performance.

## 👨‍💻 Author

**Arpan A. Shettihalli**

- GitHub: [@arpanshettihalli](https://github.com/arpanshettihalli)
- LinkedIn: [Arpan A. Shettihalli](https://www.linkedin.com/in/arpan-a-shettihalli-a31800370/)

## 📄 License

Choose an open-source license before distributing the project. The MIT License is one option if you want to permit reuse with attribution.
