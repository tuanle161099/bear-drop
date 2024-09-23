// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract BearDrop {
  struct Distributor {
    bytes32 addressRoot;
    bytes32 merkleRoot;
    bytes32 metadata;
    address authority;
    IERC20 token;
    uint total;
    uint claimed;
    uint startDate;
    uint endDate;
  }

  struct Receipt {
    uint distributorId;
    address authority;
    uint amount;
    uint claimedAt;
  }

  mapping(address => mapping(uint => Receipt)) public receipts;
  Distributor[] public distributors;
  address public owner;
  uint256 public fee;

  constructor(uint256 _fee) {
    owner = msg.sender;
    fee = _fee;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'Not the contract owner');
    _;
  }

  function setFee(uint256 _newFee) public onlyOwner {
    fee = _newFee;
  }

  event InitDistributor(
    uint256 distributorId,
    address indexed authority,
    bytes32 merkle_root,
    bytes32 address_root,
    bytes32 metadata,
    address tokenAddress,
    uint total
  );

  function initDistributor(
    bytes32 _addressRoot,
    bytes32 _merkleRoot,
    bytes32 _metadata,
    address _tokenAddress,
    uint _total,
    uint _startDate,
    uint _endDate
  ) public {
    uint index = distributors.length;
    Distributor storage distributor = distributors[index];
    distributor.addressRoot = _addressRoot;
    distributor.merkleRoot = _merkleRoot;
    distributor.authority = address(msg.sender);
    distributor.metadata = _metadata;
    distributor.token = IERC20(_tokenAddress);
    distributor.total = _total;
    distributor.startDate = _startDate;
    distributor.endDate = _endDate;
    distributor.claimed = 0;

    emit InitDistributor(
      index,
      msg.sender,
      _merkleRoot,
      _addressRoot,
      _metadata,
      _tokenAddress,
      _total
    );
  }
}
