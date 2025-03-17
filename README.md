# Health Assistant ⚕️

## About

Health Assistant is a mobile application designed to help users manage their health-related data securely. The application allows users to upload medical files and synchronize them across their devices while ensuring high standards of data privacy and security.

Users authenticate via **OAuth2** and interact with a secure backend built with **Spring Boot** to manage their personal medical data.

## Getting started

### Prerequisites

- [mise](https://mise.jdx.dev/) - Tool version manager
- [Tuist](https://tuist.io/) - Xcode project generator

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/ladislas/HealthAssistant
    cd HealthAssistant
    ```

1. Install required tools using mise (*please see mise's website for installation and activation instructions*).

    ```bash
    mise install
    ```

    This will install the following tools based on the `mise.toml` configuration:

    - [SwiftLint](https://github.com/realm/SwiftLint): Linter for Swift code to enforce best practices.
    - [SwiftFormat](https://github.com/nicklockwood/SwiftFormat): Automatic formatter to maintain consistent code style.

1. Install packages using Tuist:

    ```bash
    tuist install
    ```

1. Generate and open the Xcode project using Tuist:

    ```bash
    tuist generate # Run this command whenever you modify the project structure
    ```
