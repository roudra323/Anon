// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ANON
 * @dev A contract for posting and voting on content.
 */
contract Anon is ERC20, Pausable, Ownable {
    struct PostInfo {
        uint256 id;
        string post;
        uint256 time;
        bool downVoted;
        string[] comments;
    }

    uint256 public postID;
    PostInfo[] public allPost;
    mapping(uint256 => PostInfo) public postedInfo;
    mapping(uint256 => address) private resInfo;
    mapping(uint256 => address[]) private voters;
    mapping(uint256 => uint256) private postUP;
    mapping(uint256 => uint256) private postDown;
    mapping(address => uint256) internal blacklistedAddress;
    mapping(uint256 => mapping(address => bool)) internal isCoinMinted;

    constructor() ERC20("CSE-Token", "CSE") {
        _mint(msg.sender, 1000 * 10**decimals());
    }

    /**
     * @dev Creates a new post.
     * @param _post The content of the post.
     */
    function post(string calldata _post) external {
        require(
            blacklistedAddress[msg.sender] + 259200 <= block.timestamp,
            "You can post again after 72 hours!"
        );
        PostInfo memory tempPost = PostInfo(
            postID,
            _post,
            block.timestamp,
            false,
            new string[](0)
        );
        resInfo[postID] = msg.sender;
        postedInfo[postID] = tempPost;
        allPost.push(tempPost);
        isCoinMinted[postID][resInfo[postID]] = false;
        postID++;
    }

    /**
     * @dev Retrieves all posts.
     * @return An array of PostInfo structs representing all the posts.
     */
    function viewAllPost() external view returns (PostInfo[] memory) {
        return allPost;
    }

    /**
     * @dev Upvotes a post.
     * @param _id The ID of the post to upvote.
     */
    function upVote(uint256 _id) external voterCheck(_id, msg.sender) {
        require(allPost.length != 0, "No post found containing this id");
        require(resInfo[_id] != msg.sender, "Cannot upvote your own post");
        voters[_id].push(msg.sender);
        postUP[_id]++;
    }

    /**
     * @dev Downvotes a post.
     * @param _id The ID of the post to downvote.
     */
    function downVote(uint256 _id) external voterCheck(_id, msg.sender) {
        require(allPost.length != 0, "No post found containing this id");
        require(resInfo[_id] != msg.sender, "Cannot downvote your own post");
        voters[_id].push(msg.sender);
        postDown[_id]++;
    }

    /**
     * @dev Removes a post if it has more downvotes than upvotes in 24 hours.
     */
    function removePost() external whenNotPaused {
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < allPost.length; i++) {
            if (postedInfo[i].time + 86400 <= currentTime) {
                if (shouldDelete(i)) {
                    postedInfo[i].downVoted = true;
                    allPost[i].downVoted = true;
                    blacklistedAddress[resInfo[i]] = block.timestamp;
                } else if (
                    isUPFifty(i) && isCoinMinted[i][resInfo[i]] == false
                ) {
                    // Mint CSE token to the poster
                    isCoinMinted[i][resInfo[i]] = true;
                    mintCoin(resInfo[i], 1 * 10**(decimals() - 2));
                }
            }
        }
    }

    /**
     * @dev Allows users to edit their own posts.
     * @param _id The ID of the post to be edited.
     * @param _newPost The updated content of the post.
     */
    function editPost(uint256 _id, string calldata _newPost) external {
        require(resInfo[_id] == msg.sender, "Cannot edit other user's post");
        require(postedInfo[_id].downVoted == false, "Post already removed");
        postedInfo[_id].post = _newPost;
        allPost[_id].post = _newPost;
    }

    /**
     * @dev Adds a comment to a post.
     * @param _id The ID of the post to comment on.
     * @param _comment The comment to be added.
     */
    function addComment(uint256 _id, string calldata _comment) external {
        require(postedInfo[_id].downVoted == false, "Post already removed");
        postedInfo[_id].comments.push(_comment);
    }

    /**
     * @dev Retrieves all comments for a post.
     * @param _id The ID of the post.
     * @return An array of comments for the specified post.
     */
    function viewComments(uint256 _id) external view returns (string[] memory) {
        return postedInfo[_id].comments;
    }

    /**
     * @dev Pauses all contract functionality.
     * Can only be called by the contract owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses the contract, allowing normal functionality.
     * Can only be called by the contract owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Modifier to check if the voter has already voted on a post.
     * @param _id The ID of the post.
     * @param _addr The address of the voter.
     */
    modifier voterCheck(uint256 _id, address _addr) {
        require(postedInfo[_id].downVoted == false, "Post already removed");
        for (uint256 i = 0; i < voters[_id].length; i++) {
            if (voters[_id][i] == _addr) {
                revert("Already voted");
            }
        }
        _;
    }

    /**
     * @dev Checks if a post should be deleted.
     * @param _id The ID of the post.
     * @return A boolean indicating whether the post should be deleted.
     */
    function shouldDelete(uint256 _id) internal view returns (bool) {
        if (postUP[_id] < postDown[_id]) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Checks if the upvotes are 50% greater than the downvotes.
     * @param _id The ID of the post.
     * @return A boolean indicating whether the upvotes are 50% greater than the downvotes.
     */
    function isUPFifty(uint256 _id) internal view returns (bool) {
        uint256 fiftyPercentOfDownvotes = (postDown[_id] * 3) / 2;
        if (postUP[_id] >= fiftyPercentOfDownvotes) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Mints CSE tokens to a specified address.
     * @param acc The address to which the tokens will be minted.
     * @param amount The amount of tokens to mint.
     */
    function mintCoin(address acc, uint256 amount) internal {
        _mint(acc, amount);
    }
}
