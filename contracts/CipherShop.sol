// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./AccessControl.sol";
import "./FeeMechanism.sol";
import "./SafeMath.sol";

/// CipherShop smart contract
contract CipherShop is AccessControl, FeeMechanism {

    using SafeMath for uint256;

    /// Item struct
    struct Item {
        uint256 item_id;
        address item_owner;
        uint256 item_price;
        string item_description_hash;
        bool item_visibility;
        uint32 item_watchers;
        bool item_initializated;
        bool item_cancelled;
    }

    struct ItemTransaction {
        bool started_purchase;
        bool accepted_purchase;
        bool buyer_scrow;
        bool seller_scrow;
    }

    /// Item deposit
    struct Deposit {
        address buyer;
        address seller;
        uint256 deposit;
        bool completed;
    }

    /// List of items and states of the items
    Item[] items;
    /// Index id of the item
    uint256 items_id_index;

    /// Transaction state of the nth item
    mapping(uint256=>mapping(uint32=>ItemTransaction)) items_transactions;
    mapping(uint256=>uint32) items_transactions_id_index;

    /// Seller items. Seller address has ID of item and each item has a quantity
    mapping(address=>mapping(uint256=>uint32)) seller_items;

    /// Buyer items. Buyer address has ID of item and each item has a quantity
    mapping(address=>mapping(uint256=>uint32)) buyer_items;

    /// Address with the ids of the items to watch
    mapping(address=>uint256) watch_items;

    /// When an item initiates a transaction a Deposit is associated to the item ID
    mapping(uint256=>mapping(uint32=>Deposit)) transactions_deposit;

    function addItem(uint32 _quantity, uint256 _price, string calldata _item_description_hash) external {
        require(_quantity > 0, "Item quantity can't be 0");
        Item memory item = Item(items_id_index, msg.sender, _price, _item_description_hash, false, 0, true, false);
        items.push(item);
        seller_items[msg.sender][items_id_index] = _quantity;
        items_id_index++;
    }

    function cancelItemByOwner(uint256 _item_id) external {
        require(items[_item_id].item_owner == msg.sender);
        require(items[_item_id].item_initializated == true);
        require(items[_item_id].item_cancelled == false);
        items[_item_id].item_cancelled = true;
        //check deposits
    }

    function cancelItemByAdmin(uint256 _item_id) external onlyAdmin {
        require(items[_item_id].item_initializated == true);
        require(items[_item_id].item_cancelled == false);
        items[_item_id].item_cancelled = true;
        //check deposits
    }

    function startPurchase(uint256 _item_id, uint32 _item_quantity) external payable {
        require(items[_item_id].item_initializated == true);
        require(items[_item_id].item_cancelled == false);
        require(_item_quantity > 0);
        require(seller_items[items[_item_id].item_owner][_item_id] >= _item_quantity);
        require(msg.value >= items[_item_id].item_price.mul(_item_quantity));
        for (uint32 i = 0; i < _item_quantity ; i++) {
            items_transactions[_item_id][items_transactions_id_index[_item_id]].started_purchase = true;
            seller_items[items[_item_id].item_owner][_item_id]--;
            items_transactions_id_index[_item_id]++;
            Deposit memory deposit = Deposit(msg.sender, items[_item_id].item_owner, items[_item_id].item_price, false);
            //transactions_deposit[_item_id] = deposit;
        }
    }
}
