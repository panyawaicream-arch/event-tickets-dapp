# Event Tickets DApp

ระบบขายและตรวจบัตรงานอีเวนต์บน Ethereum (Sepolia testnet) — วิชา Blockchain

- **Contract address:** `0xYOUR_CONTRACT_ADDRESS`
- **Etherscan:** https://sepolia.etherscan.io/address/0xYOUR_CONTRACT_ADDRESS
- **Network:** Sepolia

## ฟีเจอร์
Buy Ticket (จ่าย ETH), My Tickets, Transfer, Verify, Check-in (organizer), Withdraw (organizer), แสดง tx hash + ลิงก์ Etherscan

## Design
- **ทำไมใช้ blockchain:** ตรวจความเป็นเจ้าของ/สถานะตั๋วได้โดยไม่ต้องเชื่อใจระบบกลาง กันตั๋วปลอมและใช้ซ้ำ
- **On-chain:** owner, used, ราคา, จำนวนตั๋ว
- **ทำไมออกแบบแบบนี้:** เก็บข้อมูลน้อยเพื่อลด gas, จำกัด 5 ใบ/wallet, มีเฉพาะ organizer ที่ check-in/ถอนเงิน
- **ข้อจำกัด:** public data, ต้องมี wallet/gas, แชร์ wallet = แชร์ตั๋ว, รองรับ 1 event

## วิธีรัน
1. Deploy `contracts/EventTickets.sol` บน Sepolia (Remix)
2. ใส่ address ใน `frontend/config.js`
3. `cd frontend && python3 -m http.server 8000` แล้วเปิด http://localhost:8000
4. เปิดใน browser ที่มี MetaMask (ต้องต่ออินเทอร์เน็ตเพื่อโหลด ethers.js)

## Screenshots
(ใส่ภาพหน้าจอตรงนี้)
