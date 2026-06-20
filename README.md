
# 🚗 CarRepairShop

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Status](https://img.shields.io/badge/status-stable-success)]()

> A production‑ready MySQL database for managing car repair shop operations — customers, vehicles, spare parts, repair orders, invoices, payments, and automated inventory/billing logic.

---

## 📋 Features

- **Customer & Vehicle Management** – stores personal info and vehicle details.
- **Spare Parts Inventory** – tracks part names, prices, and stock levels (non‑negative).
- **Repair Orders** – logs repairs with labor cost, used parts, and status (`OPEN`/`CLOSED`).
- **Invoices & Payments** – auto‑calculated totals; statuses (`UNPAID`, `PARTIAL`, `PAID`) updated automatically.
- **Data Integrity** – enforced via foreign keys, CHECK constraints, and triggers.
- **Reporting Views** – `InvoiceSummary` and `CriticalParts` for quick insights.
- **Sample Data** – pre‑loaded with 10 customers, 10 vehicles, 10 parts, 10 orders, etc.
- **Comprehensive Tests** – validates all business rules and edge cases.

---

## 🗄️ Schema Overview

| Table          | Description                               |
|----------------|-------------------------------------------|
| `Customer`     | Customer personal info and contact        |
| `Vehicle`      | Vehicle details linked to a customer      |
| `Part`         | Spare part catalog with stock and price   |
| `Repair_Order` | Repair jobs, labor, used parts, status    |
| `Invoice`      | Billing info, total, and payment status   |
| `Payment`      | Payments made against an invoice          |

**Relationships:**  
- Customer → Vehicle (one‑to‑many)  
- Vehicle → Repair_Order (one‑to‑many)  
- Repair_Order → Invoice (one‑to‑one)  
- Invoice → Payment (one‑to‑many)  
- Part → Repair_Order (one‑to‑many)

---

## ⚙️ Business Rules & Triggers

- **Phone & plate format** – enforced by `CHECK` constraints (Iranian mobile and plate pattern).  
- **Positive amounts** – labor, part price, and payment must be > 0; stock ≥ 0.  
- **Stock reduction** – `trg_reduce_stock` decreases part stock on new repair order (rejects if insufficient).  
- **Invoice total protection** – `trg_invoice_total_no_manual_update` prevents manual editing of `total_amount`.  
- **Payment status update** – `trg_payment_update` sets invoice status to `PAID`/`PARTIAL` and rejects overpayment.

---

## 🚀 Setup

1. **Clone** the repository.
2. **Create** the database and load sample data:
   ```bash
   mysql -u your_user -p < project.sql
   ```
3. **Run tests** to verify everything works:
   ```bash
   mysql -u your_user -p < tests.sql
   ```

> Requires MySQL 8.0+.

---

## 🧪 Test Coverage

The `tests.sql` script checks:

- ✅ Customer repair history, revenue, most used parts, debtors, unused parts, etc.
- ✅ Stock behavior after repair insertion.
- ✅ Invoice status updates after payments.
- ❌ Invalid phone formats, negative payments, overstock, manual invoice edits, and overpayments – all **rejected** as expected.

---

# 🎓 Academic Context

Developed as part of a **Database course**

📅 Spring 2026

---
