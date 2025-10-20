import cpf/cleaner
import gleam/int
import gleam/list
import gleam/regexp
import gleam/string
import utils/format
import utils/validation as utils_validation

pub fn handle_flexible_validation(cpf: String) {
  let cleaned_cpf = cleaner.clean(cpf)

  case string.length(cleaned_cpf) {
    11 -> {
      handle_cleaned_cpf(cleaned_cpf)
    }
    _ -> False
  }
}

pub fn handle_strict_validation(cpf: String) {
  let cpf_regex = format.unformatted_cpf_regex()

  let is_regex_valid = regexp.check(cpf_regex, cpf)

  case is_regex_valid {
    True -> handle_flexible_validation(cpf)
    False -> False
  }
}

fn handle_cleaned_cpf(cpf: String) {
  case format.all_characteres_are_equal(cpf) {
    True -> False
    False -> calculate_verification_digits_and_validate(cpf)
  }
}

fn calculate_verification_digits_and_validate(cpf: String) {
  let digits = string.to_graphemes(cpf)
  let #(first_nine_digits, rest) = list.split(digits, 9)
  let last_two_digits = list.take(rest, 2)

  let first_verification_digit =
    calculate_first_verification_digit(first_nine_digits)
  let ten_digits =
    list.append(first_nine_digits, [int.to_string(first_verification_digit)])

  let second_verification_digit =
    calculate_second_verification_digit(ten_digits)

  last_two_digits
  == [
    int.to_string(first_verification_digit),
    int.to_string(second_verification_digit),
  ]
}

pub fn calculate_first_verification_digit(first_nine_digits: List(String)) {
  let sum =
    list.index_fold(first_nine_digits, 0, fn(acc, elm, index) {
      let assert Ok(integer_number) = int.parse(elm)

      acc + integer_number * { 10 - index }
    })

  let last_sum_checker = sum % 11

  utils_validation.calculate_verification_digit_mod11(last_sum_checker)
}

pub fn calculate_second_verification_digit(ten_digits: List(String)) {
  let sum =
    list.index_fold(ten_digits, 0, fn(acc, elm, index) {
      let assert Ok(integer_number) = int.parse(elm)

      acc + integer_number * { 11 - index }
    })

  let last_sum_checker = sum % 11

  utils_validation.calculate_verification_digit_mod11(last_sum_checker)
}
