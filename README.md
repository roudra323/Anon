# ANON Contract

ANON is a Solidity contract that enables anonymous posting and voting on content. Users can create posts anonymously, upvote and downvote posts, and posts are automatically deleted after 24 hours based on the voting results.

## Features

- Create posts anonymously with content and timestamp
- Upvote and downvote posts
- Automatic deletion of posts after 24 hours based on voting results
- Automatic post removal based on downvotes.
- Minting of CSE tokens for posts with a certain threshold of upvotes.
- Blacklisting and whitelisting of addresses.

## Getting Started

### Prerequisites

- Solidity development environment
- Ethereum network or a local blockchain for deployment and testing

### Deployment

1. Clone the repository:

   ```shell
   git clone https://github.com/your-username/ANON-contract.git
    ```

2. Compile the contract using a Solidity compiler of your choice.

3. Deploy the contract to an Ethereum network or a local blockchain.

4. Interact with the contract using a web interface or through a Solidity development environment.

### Usage

The contract provides the following **functions**:

**post(string calldata _post, string calldata _time)**: Create a new post anonymously with the given content and timestamp.

**viewAllpost()**: Retrieve an array of all posts.

**upVote(uint256 _id)**: Upvote a post specified by its ID.

**downVote(uint256 _id)**: Downvote a post specified by its ID.

**removePost()**: Removes a post if it has received more downvotes than upvotes within 24 hours. The removal is based on the voting results and is performed automatically.


The posts are automatically deleted after 24 hours based on the voting results. If a post receives a higher number of downvotes than upvotes within this timeframe, it will be removed from the contract.

### Contributing

Contributions to ANON Contract are welcome! If you encounter any bugs, issues, or have suggestions for improvements, please open an issue or submit a pull request.

### License

This project is licensed under the MIT License.
