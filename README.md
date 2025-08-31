# 🎓 Kampus Smart Contract

Smart contract that simulates various functionalities of a campus management system to demonstrate fundamental and advanced concepts of Move and the Sui ecosystem, such as Sui Objects, Shared Objects, Owned Objects, and Capabilities.

## 📦 Project Structure

The program consists of several modules, each focusing on a specific functionality:

fungsi_string: Manages String data, including creating, modifying, and getting a student's name.

fungsi_number: Manages numerical data types like u32 (Student ID), u8 (age), and u64 (total credits).

fungsi_boolean: Uses the bool data type to track a student's status (active or graduated).

data_mahasiswa_lengkap: Combines all primitive data types into a comprehensive student object.

fungsi_vector: Demonstrates how to use a vector to store lists of students within a single object.

owned_objects: Explains the concept of Owned Objects, where an object (like a student card) is owned and managed by a single address.

shared_objects: Explains Shared Objects, which can be accessed and modified by multiple parties, with access control defined within the contract's logic.

capabilities_pattern: Shows the Capabilities design pattern, where specific objects (like AdminCap or DosenCap) are used as a "key" to authorize specific actions, such as giving a grade.

fungsi_lengkap: Combines concepts like validation, if/else, while, and multiple return values for more complex workflows.

## Command to run the project

To run the project, you need to have the Sui CLI installed. You can download it from the official website: https://docs.sui.io/build/install

Once you have the Sui CLI installed, you can run the following command to compile and run the project:

```bash
sui move build
```

## 📝 Usage

```bash
sui client call \
 --package 0xcedb9a4f36d461a0f3a1d911a153620e73c6965e806e46b65b659afff645cb6a \
 --module belajar_number \
 --function buat_data_mahasiswa \
 --args 12345 17 \
 --gas-budget 2000000
```
