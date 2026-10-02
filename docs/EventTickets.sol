// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EventTickets - simple on-chain event ticketing (single event)
contract EventTickets {
    struct Ticket { address owner; bool used; }

    address public organizer;
    string public eventName;
    string public venue;
    string public eventDate;
    uint256 public price;        // wei per ticket
    uint256 public maxSupply;
    uint256 public sold;
    uint256 public constant MAX_PER_WALLET = 5;

    mapping(uint256 => Ticket) private tickets;      // ids start at 1
    mapping(address => uint256[]) private ownedIds;

    event TicketPurchased(uint256 indexed ticketId, address indexed buyer);
    event TicketCheckedIn(uint256 indexed ticketId, address indexed owner);
    event TicketTransferred(uint256 indexed ticketId, address indexed from, address indexed to);
    event Withdrawn(address indexed organizer, uint256 amount);

    modifier onlyOrganizer() { require(msg.sender == organizer, "Only organizer"); _; }

    constructor(string memory _name, string memory _venue, string memory _date, uint256 _priceWei, uint256 _maxSupply) {
        require(_maxSupply > 0, "Supply must be > 0");
        organizer = msg.sender;
        eventName = _name; venue = _venue; eventDate = _date;
        price = _priceWei; maxSupply = _maxSupply;
    }

    function buyTicket() external payable returns (uint256 id) {
        require(sold < maxSupply, "Sold out");
        require(msg.value == price, "Wrong ETH amount");
        require(ownedIds[msg.sender].length < MAX_PER_WALLET, "Max 5 tickets per wallet");
        id = ++sold;
        tickets[id] = Ticket(msg.sender, false);
        ownedIds[msg.sender].push(id);
        emit TicketPurchased(id, msg.sender);
    }

    /// Organizer scans the ticket at the door; each ticket can be used once.
    function checkIn(uint256 id) external onlyOrganizer {
        Ticket storage t = tickets[id];
        require(t.owner != address(0), "Ticket does not exist");
        require(!t.used, "Already checked in");
        t.used = true;
        emit TicketCheckedIn(id, t.owner);
    }

    function transferTicket(uint256 id, address to) external {
        Ticket storage t = tickets[id];
        require(t.owner == msg.sender, "Not ticket owner");
        require(!t.used, "Ticket already used");
        require(to != address(0) && to != msg.sender, "Invalid recipient");
        require(ownedIds[to].length < MAX_PER_WALLET, "Recipient has max tickets");
        uint256[] storage arr = ownedIds[msg.sender];
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == id) { arr[i] = arr[arr.length - 1]; arr.pop(); break; }
        }
        ownedIds[to].push(id);
        t.owner = to;
        emit TicketTransferred(id, msg.sender, to);
    }

    function withdraw() external onlyOrganizer {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw");
        (bool ok, ) = payable(organizer).call{value: amount}("");
        require(ok, "Withdraw failed");
        emit Withdrawn(organizer, amount);
    }

    function getTicket(uint256 id) external view returns (address owner, bool used) {
        require(tickets[id].owner != address(0), "Ticket does not exist");
        return (tickets[id].owner, tickets[id].used);
    }

    function getTicketsOf(address user) external view returns (uint256[] memory) { return ownedIds[user]; }
}
