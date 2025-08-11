pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Counters.sol";

contract DecentralizedChatbotGenerator {
    using SafeERC20 for address;
    using Counters for Counters.Counter;

    // Mapping of chatbot IDs to their corresponding metadata
    mapping (uint256 => Chatbot) public chatbots;

    // Mapping of user addresses to their owned chatbots
    mapping (address => uint256[]) public userChatbots;

    // Counter for chatbot IDs
    Counters.Counter public chatbotCounter;

    // Event emitted when a new chatbot is created
    event NewChatbot(uint256 chatbotId, address owner, string chatbotName);

    // Event emitted when a chatbot is deployed
    event DeployedChatbot(uint256 chatbotId, address chatbotAddress);

    // Event emitted when a user interacts with a chatbot
    event InteractedWithChatbot(uint256 chatbotId, address user, string input);

    // Struct to represent a chatbot
    struct Chatbot {
        uint256 id;
        address owner;
        string name;
        string description;
        address chatbotAddress;
    }

    // Function to create a new chatbot
    function createChatbot(string memory _name, string memory _description) public {
        chatbotCounter.increment();
        uint256 newId = chatbotCounter.current();
        Chatbot storage newChatbot = chatbots[newId];
        newChatbot.id = newId;
        newChatbot.owner = msg.sender;
        newChatbot.name = _name;
        newChatbot.description = _description;
        userChatbots[msg.sender].push(newId);
        emit NewChatbot(newId, msg.sender, _name);
    }

    // Function to deploy a chatbot
    function deployChatbot(uint256 _chatbotId) public {
        require(msg.sender == chatbots[_chatbotId].owner, "Only the chatbot owner can deploy it");
        address chatbotAddress = deployChatbotContract(_chatbotId);
        chatbots[_chatbotId].chatbotAddress = chatbotAddress;
        emit DeployedChatbot(_chatbotId, chatbotAddress);
    }

    // Function to interact with a deployed chatbot
    function interactWithChatbot(uint256 _chatbotId, string memory _input) public {
        require(chatbots[_chatbotId].chatbotAddress != address(0), "Chatbot is not deployed");
        (bool success, ) = chatbots[_chatbotId].chatbotAddress.call(abi.encodeWithSignature("interact(string)", _input));
        require(success, "Failed to interact with chatbot");
        emit InteractedWithChatbot(_chatbotId, msg.sender, _input);
    }

    // Internal function to deploy a chatbot contract
    function deployChatbotContract(uint256 _chatbotId) internal returns (address) {
        // TO DO: implement chatbot contract deployment logic
    }
}