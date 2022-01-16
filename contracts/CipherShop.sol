// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./AccessControl.sol";
import "./FeeMechanism.sol";
import "./SafeMath.sol";
import "./IERC20.sol";
import "./Cshop.sol";

/// CipherShop smart contract
contract CipherShop is AccessControl, FeeMechanism {

    using SafeMath for uint256;

    uint256 seller_reward = 300e18;
    uint256 buyer_reward = 50e18;

    IERC20 reward_token;

    mapping(address=>uint256) private pending_rewards;

    /// Item struct
    struct Item {
        uint256 item_id;
        address item_owner;
        uint256 item_price;
        string item_name;
        string item_description;
        string item_pictures_hash;
        uint256 item_category;
        uint256 item_location;
        uint256 item_sending_location;
        uint256 item_sending_method;
        uint256 item_arrival_time;
        bool item_accept_erc20;
        IERC20 item_currency;
        bool item_admits_devolution;
        bool item_visibility;
        bool item_private;
        uint256 item_watchers;
        bool item_initialized;
        bool item_cancelled;
        bool item_cancelled_by_admin;
    }

    struct ItemTransaction {
        uint256 item_transaction_id;
        bool started_purchase;
        bool accepted_purchase;
        bool marked_as_sent;
        bool marked_as_received;
        bool marked_as_received_by_seller;
        bool started_devolution;
        bool marked_devolution_as_sent;
        bool marked_devolution_as_received;
        bool marked_devolution_as_received_by_buyer;
        bool buyer_screw;
        bool seller_screw;
        address payable buyer;
        address payable seller;
        bool accept_erc20;
        IERC20 currency;
        uint256 quantity;
        uint256 deposit;
        bool completed;
    }

    /// List of items and states of the items
    mapping(uint256=>Item) private items;
    /// Index id of the item
    uint256 private items_id_index;

    mapping(uint256=>uint256) private items_quantities;

    /// Transaction state of the nth item
    mapping(uint256=>mapping(uint256=>ItemTransaction)) private items_transactions;
    mapping(uint256=>uint256) private items_transactions_id_index;

    mapping(address=>uint256[]) private seller_items;

    /// Buyer items. Buyer address has ID of item and each item has a quantity
    mapping(address=>uint256[]) private buyer_items;

    /// Address with the ids of the items to watch
    mapping(address=>uint256[]) private watch_items;

    mapping(uint256=>mapping(address=>bool)) private items_white_list;

    function getItem(uint256 _item_id) external view returns (address item_owner, uint256 item_price, string memory item_name, string memory item_description, string memory item_pictures_hash, uint256 item_category, uint256 item_location, uint256 item_sending_location, uint256 item_sending_method, uint256 item_arrival_time, bool item_accept_erc20, IERC20 item_currency, bool item_admits_devolution, bool item_visibility, bool item_private, uint256 item_watchers, bool item_cancelled, bool item_cancelled_by_admin) {
        require(items[_item_id].item_initialized, "Item doesn't exist");
        if(!items[_item_id].item_visibility) {
            require(items[_item_id].item_owner == msg.sender);
        }
        if(items[_item_id].item_private) {
            require(items[_item_id].item_owner == msg.sender || items_white_list[_item_id][msg.sender]);
        }
        item_owner = items[_item_id].item_owner;
        item_price = items[_item_id].item_price;
        item_name = items[_item_id].item_name;
        item_description = items[_item_id].item_description;
        item_pictures_hash = items[_item_id].item_pictures_hash;
        item_category = items[_item_id].item_category;
        item_location = items[_item_id].item_location;
        item_sending_location = items[_item_id].item_sending_location;
        item_sending_method = items[_item_id].item_sending_method;
        item_arrival_time = items[_item_id].item_arrival_time;
        item_accept_erc20 = items[_item_id].item_accept_erc20;
        item_currency = items[_item_id].item_currency;
        item_admits_devolution = items[_item_id].item_admits_devolution;
        item_visibility = items[_item_id].item_visibility;
        item_private = items[_item_id].item_private;
        item_watchers = items[_item_id].item_watchers;
        item_cancelled = items[_item_id].item_cancelled;
        item_cancelled_by_admin = items[_item_id].item_cancelled_by_admin;
    }

    function getItemQuantity(uint256 _item_id) external view returns (uint256 quantity) {
        quantity = items_quantities[_item_id];
    }

    function setItem(uint256 _item_id, address _item_owner, uint256 _item_price, string calldata _item_name, string calldata _item_description, string calldata _item_pictures_hash, uint256 _item_category, uint256 _item_location, uint256 _item_sending_location, uint256 _item_sending_method, uint256 _item_arrival_time, bool _item_accept_erc20, IERC20 _item_currency, bool _item_admits_devolution, bool _item_visibility, bool _item_private) external {
        require(items[_item_id].item_initialized);
        require(items[_item_id].item_owner == msg.sender);
        items[_item_id].item_owner = _item_owner;
        items[_item_id].item_price = _item_price;
        items[_item_id].item_name = _item_name;
        items[_item_id].item_description = _item_description;
        items[_item_id].item_pictures_hash = _item_pictures_hash;
        items[_item_id].item_category = _item_category;
        items[_item_id].item_location = _item_location;
        items[_item_id].item_sending_location = _item_sending_location;
        items[_item_id].item_sending_method = _item_sending_method;
        items[_item_id].item_arrival_time = _item_arrival_time;
        items[_item_id].item_accept_erc20 = _item_accept_erc20;
        items[_item_id].item_currency = _item_currency;
        items[_item_id].item_admits_devolution = _item_admits_devolution;
        items[_item_id].item_visibility = _item_visibility;
        items[_item_id].item_private = _item_private;
    }

    function setItemQuantity(uint256 _item_id, uint256 _quantity) external {
        require(items[_item_id].item_initialized);
        require(items[_item_id].item_owner == msg.sender);
        items_quantities[_item_id] = _quantity;
    }

    function addAddressesWhiteListItem(uint256 _item_id, address[] calldata _addresses) external {
        require(items[_item_id].item_initialized);
        require(items[_item_id].item_owner == msg.sender);
        require(items[_item_id].item_private);
        for (uint256 i = 0; i < _addresses.length; i++) {
            items_white_list[_item_id][_addresses[i]] = true;
        }
    }

    function removeAddressesWhiteListItem(uint256 _item_id, address[] calldata _addresses) external {
        require(items[_item_id].item_initialized);
        require(items[_item_id].item_owner == msg.sender);
        require(items[_item_id].item_private);
        for (uint256 i = 0; i < _addresses.length; i++) {
            items_white_list[_item_id][_addresses[i]] = false;
        }
    }

    function getSellerItemsIds() external view returns (uint256[] memory items_ids) {
        items_ids = seller_items[msg.sender];
    }

    function getBuyerItemsIds() external view returns (uint256[] memory items_ids) {
        items_ids = buyer_items[msg.sender];
    }

    function getWatchingItems() external view returns (uint256[] memory items_ids) {
        items_ids = watch_items[msg.sender];
    }

    function getItemsByCategory(uint256[] calldata _categories) external view {
        //TODO
    }

    function getPublicItems() external view {
        //TODO
    }

    function addItem(uint256 _quantity, uint256 _price, string calldata _item_name, string calldata _item_description, string calldata _item_pictures_hash, uint256 _item_category, uint256 _item_location, uint256 _item_sending_location, uint256 _item_sending_method, uint256 _item_arrival_time, bool _item_accept_erc20, IERC20 _item_currency, bool _item_admits_devolution, bool _item_private, bool _item_visibility) external {
        require(_quantity > 0, "Item quantity can't be 0");
        Item memory item = Item(items_id_index, msg.sender, _price, _item_name, _item_description, _item_pictures_hash, _item_category, _item_location, _item_sending_location, _item_sending_method, _item_arrival_time, _item_accept_erc20, _item_currency, _item_admits_devolution, _item_private, _item_visibility, 0, true, false, false);
        item.item_initialized = true;
        items[items_id_index] = item;
        items_quantities[items_id_index] = _quantity;
        items_id_index.add(1);
    }

    function cancelItemByOwner(uint256 _item_id) external {
        require(items[_item_id].item_owner == msg.sender);
        require(items[_item_id].item_initialized == true);
        require(items[_item_id].item_cancelled == false);
        for (uint256 i = 0; i < items_transactions_id_index[_item_id]; i++) {
            if (items_transactions[_item_id][i].started_purchase && !items_transactions[_item_id][i].accepted_purchase) {
                if (!items_transactions[_item_id][i].completed) {
                    if (items_transactions[_item_id][i].accept_erc20) {
                        items_transactions[_item_id][i].currency.transfer(items_transactions[_item_id][i].buyer, items_transactions[_item_id][i].deposit);
                    } else {
                        transfer(items_transactions[_item_id][i].buyer, items_transactions[_item_id][i].deposit);
                    }
                    items_transactions[_item_id][i].completed = true;
                }
            }
        }
        items[_item_id].item_cancelled = true;
    }

    function cancelItemByAdmin(uint256 _item_id) external onlyAdmin {
        require(items[_item_id].item_initialized == true);
        require(items[_item_id].item_cancelled == false);
        for (uint256 i = 0; i < items_transactions_id_index[_item_id]; i++) {
            if (items_transactions[_item_id][i].started_purchase && !items_transactions[_item_id][i].accepted_purchase) {
                if (!items_transactions[_item_id][i].completed) {
                    if (items_transactions[_item_id][i].accept_erc20) {
                        items_transactions[_item_id][i].currency.transfer(items_transactions[_item_id][i].buyer, items_transactions[_item_id][i].deposit);
                    } else {
                        transfer(items_transactions[_item_id][i].buyer, items_transactions[_item_id][i].deposit);
                    }
                    items_transactions[_item_id][i].completed = true;
                }
            }
        }
        items[_item_id].item_cancelled = true;
    }

    function restartItemByOwner(uint256 _item_id) external {
        require(items[_item_id].item_initialized == true);
        require(items[_item_id].item_cancelled == true);
        require(items[_item_id].item_cancelled_by_admin == false);
        items[_item_id].item_cancelled = false;
    }

    function restartItemByAdmin(uint256 _item_id) external onlyAdmin {
        require(items[_item_id].item_initialized == true);
        require(items[_item_id].item_cancelled == true);
        require(items[_item_id].item_cancelled_by_admin == true);
        items[_item_id].item_cancelled = false;
        items[_item_id].item_cancelled_by_admin = false;
    }

    function startPurchase(uint256 _item_id, uint256 _item_quantity) external payable {
        require(items[_item_id].item_initialized == true);
        require(items[_item_id].item_cancelled == false);
        require(items[_item_id].item_visibility);
        if (items[_item_id].item_private) {
            require(items_white_list[_item_id][msg.sender] == true);
        }
        require(_item_quantity > 0);
        require(items_quantities[_item_id] >= _item_quantity);
        require(msg.value >= items[_item_id].item_price.mul(_item_quantity));
        ItemTransaction memory item_transaction = ItemTransaction(items_transactions_id_index[_item_id], true, false, false, false, false, false, false, false, false, false, false, payable(msg.sender), payable(items[_item_id].item_owner), items[_item_id].item_accept_erc20, items[_item_id].item_currency, _item_quantity, items[_item_id].item_price.mul(_item_quantity), false);
        items_quantities[_item_id].sub(_item_quantity);
        items_transactions[_item_id][items_transactions_id_index[_item_id]] = item_transaction;
        items_transactions_id_index[_item_id].add(1);
    }

    function cancelTransactionByBuyer(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(!items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        if (items_transactions[_item_id][_transaction_id].accept_erc20) {
            items_transactions[_item_id][_transaction_id].currency.transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
        } else {
            transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
        }
        items_transactions[_item_id][_transaction_id].completed = true;
        items_quantities[_item_id].add(items_transactions[_item_id][_transaction_id].quantity);
    }

    function cancelTransactionBySeller(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(!items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].seller == msg.sender);
        if (items_transactions[_item_id][_transaction_id].accept_erc20) {
            items_transactions[_item_id][_transaction_id].currency.transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
        } else {
            transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
        }
        items_transactions[_item_id][_transaction_id].completed = true;
        items_quantities[_item_id].add(items_transactions[_item_id][_transaction_id].quantity);
    }

    function markTransactionAsSent(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(!items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].seller == msg.sender);
        items_transactions[_item_id][_transaction_id].marked_as_sent = true;
    }

    function markTransactionAsReceivedByBuyer(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        uint256 fee = applyFee(items_transactions[_item_id][_transaction_id].deposit, items_transactions[_item_id][_transaction_id].accept_erc20, items_transactions[_item_id][_transaction_id].currency);
        uint256 value = items_transactions[_item_id][_transaction_id].deposit.sub(fee);
        if (items_transactions[_item_id][_transaction_id].accept_erc20) {
            items_transactions[_item_id][_transaction_id].currency.transfer(items_transactions[_item_id][_transaction_id].seller, value);
        } else {
            transfer(items_transactions[_item_id][_transaction_id].seller, value);
        }
        items_transactions[_item_id][_transaction_id].completed = true;
        pending_rewards[items_transactions[_item_id][_transaction_id].buyer].add(buyer_reward);
        pending_rewards[items_transactions[_item_id][_transaction_id].seller].add(seller_reward);
    }

    function markTransactionAsReceivedBySeller(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].seller == msg.sender);
        items_transactions[_item_id][_transaction_id].marked_as_received_by_seller = true;
    }

    function startScrewByBuyer(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(!items_transactions[_item_id][_transaction_id].buyer_screw);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        items_transactions[_item_id][_transaction_id].buyer_screw = true;
    }

    function startScrewBySeller(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(!items_transactions[_item_id][_transaction_id].seller_screw);
        require(items_transactions[_item_id][_transaction_id].seller == msg.sender);
        items_transactions[_item_id][_transaction_id].seller_screw = true;
    }

    function resolveScrewByBuyer(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].buyer_screw);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        items_transactions[_item_id][_transaction_id].buyer_screw = false;
    }

    function resolveScrewBySeller(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].buyer_screw);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        items_transactions[_item_id][_transaction_id].buyer_screw = false;
    }

    function resolveScrewByAdmin(uint256 _item_id, uint256 _transaction_id, bool _true_to_seller_false_to_buyer) external onlyAdmin {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].buyer_screw || items_transactions[_item_id][_transaction_id].seller_screw);
        if (_true_to_seller_false_to_buyer) {
            uint256 fee = applyFee(items_transactions[_item_id][_transaction_id].deposit, items_transactions[_item_id][_transaction_id].accept_erc20, items_transactions[_item_id][_transaction_id].currency);
            uint256 value = items_transactions[_item_id][_transaction_id].deposit.sub(fee);
            if (items_transactions[_item_id][_transaction_id].accept_erc20) {
                items_transactions[_item_id][_transaction_id].currency.transfer(items_transactions[_item_id][_transaction_id].seller, value);
            } else {
                transfer(items_transactions[_item_id][_transaction_id].seller, value);
            }
        } else {
            if (items_transactions[_item_id][_transaction_id].accept_erc20) {
                items_transactions[_item_id][_transaction_id].currency.transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
            } else {
                transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
            }
        }
        items_transactions[_item_id][_transaction_id].completed = true;
    }

    function markTransactionAsDevolution(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items[_item_id].item_admits_devolution);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        items_transactions[_item_id][_transaction_id].started_devolution = true;
    }

    function markTransactionAsDevolutionAsSent(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].started_devolution);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        items_transactions[_item_id][_transaction_id].marked_devolution_as_sent = true;
    }

    function markTransactionAsDevolutionAsReceivedBySeller(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].started_devolution);
        require(items_transactions[_item_id][_transaction_id].marked_devolution_as_sent);
        require(items_transactions[_item_id][_transaction_id].seller == msg.sender);
        if (items_transactions[_item_id][_transaction_id].accept_erc20) {
            items_transactions[_item_id][_transaction_id].currency.transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
        } else {
            transfer(items_transactions[_item_id][_transaction_id].buyer, items_transactions[_item_id][_transaction_id].deposit);
        }
        items_transactions[_item_id][_transaction_id].completed = true;
        items_quantities[_item_id].add(items_transactions[_item_id][_transaction_id].quantity);
    }

    function markTransactionAsDevolutionAsReceivedByBuyer(uint256 _item_id, uint256 _transaction_id) external {
        require(items[_item_id].item_initialized);
        require(items_transactions[_item_id][_transaction_id].started_purchase);
        require(!items_transactions[_item_id][_transaction_id].completed);
        require(items_transactions[_item_id][_transaction_id].marked_as_sent);
        require(items_transactions[_item_id][_transaction_id].started_devolution);
        require(items_transactions[_item_id][_transaction_id].marked_devolution_as_sent);
        require(items_transactions[_item_id][_transaction_id].buyer == msg.sender);
        items_transactions[_item_id][_transaction_id].marked_devolution_as_received_by_buyer = true;
    }

    function changeRewardToken(IERC20 _token) external onlyAdmin {
        reward_token = _token;
    }

    function airdropRewards(address[] calldata _recipients) external onlyAdmin {
        for(uint256 i = 0; i < _recipients.length; i++) {
            bool success = reward_token.transfer(_recipients[i], pending_rewards[_recipients[i]]);
            if (success) {
                pending_rewards[_recipients[i]] = 0;
            }
        }
    }

    function withdrawRewards() external {
        require(pending_rewards[msg.sender] > 0);
        bool success = reward_token.transfer(msg.sender, pending_rewards[msg.sender]);
        if (success) {
            pending_rewards[msg.sender] = 0;
        }
    }

    function changeSellerReward(uint256 _reward) external onlyAdmin {
        seller_reward = _reward;
    }

    function changeBuyerReward(uint256 _reward) external onlyAdmin {
        buyer_reward = _reward;
    }

    function transfer(address payable _to, uint256 _quantity) internal {
        (bool sent, bytes memory data) = _to.call{value: _quantity}("");
        require(sent, "Failed to send Ether");
    }

    fallback() external payable {}
    receive() external payable {}
}
