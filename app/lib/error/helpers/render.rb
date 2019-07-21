module Error::Helpers
  class Render
    def self.json(status_code, turing_code, field)
      custom_errors = {
        "AUT_01": "Authorization code is empty.",
        "AUT_02": "Access Unauthorized.",
        "PAG_01": "The order is not matched 'field,(DESC|ASC)'.",
        "PAG_02": "The field of order is not allow sorting.",
        "USR_01": "Email or Password is invalid.",
        "USR_02": "The field(s) are/is required.",
        "USR_03": "The email is invalid.",
        "USR_04": "The email already exists.",
        "USR_05": "The email doesn't exist.",
        "USR_06": "This is an invalid phone number.",
        "USR_07": "This is too long <#{field}>",
        "USR_08": "This is an invalid Credit Card.",
        "USR_09": "The Shipping Region ID is not number.",
        "USR_10": "Password should be atleast 6 characters.",
        "USR_11": "Maximum field length exceeded.",
        "USR_12": "Postal code is not a number",
        "CAT_01": "Don't exist category with this ID.",
        "CAT_02": "The ID is not a number.",
        "DEP_01": "The ID is not a number.",
        "DEP_02": "Don't exist department with this ID.",
        "PRO_01": "The ID is not a number.",
        "PRO_02": "Don't exist product with this ID.",
        "PRO_03": "Product has no category.",
        "ATT_01": "The ID is not a number.",
        "ATT_02": "Don't exist attribute with this ID.",
        "ISE": "Internal server error.",
        "CAR_01": "Don't exist a shopping cart item with this ID",
        "CAR_02": "The ID is not a number.",
        "CAR_03": "The quantity is not a number.",
        "TAX_01": "The ID is not a number.",
        "TAX_02": "Don't exist tax with this ID.",
        "SHI_01": "The ID is not a number.",
        "SHI_02": "Don't exist a shipping region with this ID",
        "SHI_03": "Don't exist shipping with this ID",
        "0RD_01": "The ID is not a number.",
        "ORD_02": "Don't exist an order with this ID",
        "STR_01": "Stripe charge unsuccessful",
        "STR_02": "Stripe charge amount is not a number ",
        "RAT_01": "The ID is not a number.",
        "UNPROCESSABLE": "Unprocessable entity."
      }

      error = {
        "error": {
          "status": status_code,
          "code": turing_code,
          "message": custom_errors[turing_code],
          "field": field
        }.as_json
      }

    end
  end
end