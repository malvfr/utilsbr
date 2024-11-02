import gleam/int
import gleam/list
import gleam/regex
import gleam/string

pub fn validate(cpf: String) -> Bool {
  let cleaned_cpf = clean_cpf(cpf)

  case string.length(cleaned_cpf) {
    11 -> {
      handle_cleaned_cpf(cleaned_cpf)
    }
    _ -> False
  }
}

fn clean_cpf(cpf: String) {
  let assert Ok(only_numbers_regex) = regex.from_string("[^0-9]")

  regex.replace(each: only_numbers_regex, in: cpf, with: "")
}

fn handle_cleaned_cpf(cpf: String) {
  case are_all_digits_equal(cpf) {
    True -> False
    False -> calculate_verification_digits_and_validate(cpf)
  }
}

fn are_all_digits_equal(cpf: String) {
  cpf
  |> string.split("")
  |> list.all(fn(elm) { elm == string.slice(cpf, 0, 1) })
}

fn calculate_verification_digits_and_validate(cpf: String) {
  let first_nine_digits = string.slice(cpf, 0, 9) |> string.split("")
  let last_two_digits = string.slice(cpf, 9, 11) |> string.split("")

  let first_verification_digit =
    calculate_first_verification_digit(first_nine_digits)
  let ten_digits =
    list.append(first_nine_digits, [int.to_string(first_verification_digit)])

  let second_verification_digit =
    calculate_second_verification_digit(ten_digits)
  let is_valid =
    last_two_digits
    == [
      int.to_string(first_verification_digit),
      int.to_string(second_verification_digit),
    ]

  is_valid
}

fn calculate_first_verification_digit(first_nine_digits: List(String)) {
  let sum =
    list.index_fold(first_nine_digits, 0, fn(acc, elm, index) {
      let assert Ok(integer_number) = int.parse(elm)

      acc + integer_number * { 10 - index }
    })

  let last_sum_checker = sum % 11

  calculate_verification_digit(last_sum_checker)
}

fn calculate_second_verification_digit(ten_digits: List(String)) {
  let sum =
    list.index_fold(ten_digits, 0, fn(acc, elm, index) {
      let assert Ok(integer_number) = int.parse(elm)

      acc + integer_number * { 11 - index }
    })

  let last_sum_checker = sum % 11

  calculate_verification_digit(last_sum_checker)
}

fn calculate_verification_digit(last_sum_checker: Int) {
  let first_verification_digit = case last_sum_checker {
    0 -> 0
    1 -> 0
    _ -> 11 - last_sum_checker
  }

  first_verification_digit
}
