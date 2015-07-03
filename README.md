# CreditCardProcessor

Basic credit card processing cli application. Takes input from stdin or from file. Validates card numbers via Luhn. Designed at the core with immutable entities.

## Installation

Run `bin/setup` to install dependencies

## Usage

### STDIN

run `bin/process` takes stdin.

Commands 

  `add person_name credit_card_number credit_limit`
  
  `charge person_name amount`
  
  `credit person_name amount`
  
  `exit` To quit and see summary.

### File Path

run `bin/process example_input.txt`
 