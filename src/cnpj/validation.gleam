import cnpj/alphanumeric
import cnpj/cleaner
import gleam/int
import gleam/list
import gleam/regexp
import gleam/string
import utils/format
import utils/validation as utils_validation

fn has_letters(str: String) -> Bool {
  string.to_graphemes(str)
  |> list.any(fn(char) {
    case char {
      "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "." | "-"
      | "/" -> False
      _ -> True
    }
  })
}

pub fn handle_flexible_validation(cnpj: String) {
  case has_letters(cnpj) {
    True -> {
      let cleaned_cnpj = alphanumeric.clean_alphanumeric(cnpj)
      case string.length(cleaned_cnpj) {
        14 -> alphanumeric.validate_alphanumeric(cleaned_cnpj)
        _ -> False
      }
    }
    False -> {
      let cleaned_cnpj = cleaner.clean(cnpj)
      case string.length(cleaned_cnpj) {
        14 -> handle_cleaned_cnpj(cleaned_cnpj)
        _ -> False
      }
    }
  }
}

pub fn handle_strict_validation(cnpj: String) {
  let cnpj_regex = format.unformatted_cnpj_regex()

  let is_regex_valid = regexp.check(cnpj_regex, cnpj)

  case is_regex_valid {
    True -> handle_flexible_validation(cnpj)
    False -> False
  }
}

fn handle_cleaned_cnpj(cnpj: String) {
  case format.all_characteres_are_equal(cnpj) {
    True -> False
    False -> calculate_verification_digits_and_validate(cnpj)
  }
}

fn calculate_verification_digits_and_validate(cnpj: String) {
  let digits = string.to_graphemes(cnpj)
  let #(first_twelve_digits, rest) = list.split(digits, 12)
  let last_two_digits = list.take(rest, 2)

  let first_verification_digit =
    calculate_first_verification_digit(first_twelve_digits)

  let thirteen_digits =
    list.append(first_twelve_digits, [int.to_string(first_verification_digit)])

  let second_verification_digit =
    calculate_second_verification_digit(thirteen_digits)

  last_two_digits
  == [
    int.to_string(first_verification_digit),
    int.to_string(second_verification_digit),
  ]
}

pub fn calculate_first_verification_digit(first_twelve_digits: List(String)) {
  let verifying_digits = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  let sum =
    list.zip(first_twelve_digits, verifying_digits)
    |> list.fold(0, fn(acc, pair) {
      let #(elm, verifying_digit) = pair
      let assert Ok(digit) = int.parse(elm)
      acc + digit * verifying_digit
    })

  let last_sum_checker = sum % 11

  utils_validation.calculate_verification_digit_mod11(last_sum_checker)
}

pub fn calculate_second_verification_digit(thirteen_digits: List(String)) {
  let verifying_digits = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  let sum =
    list.zip(thirteen_digits, verifying_digits)
    |> list.fold(0, fn(acc, pair) {
      let #(elm, verifying_digit) = pair
      let assert Ok(digit) = int.parse(elm)
      acc + digit * verifying_digit
    })

  let last_sum_checker = sum % 11

  utils_validation.calculate_verification_digit_mod11(last_sum_checker)
}
