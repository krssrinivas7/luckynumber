from flask import Flask, render_template, request

app = Flask(__name__)


def calculate_lucky_number(birth_date):
    day, month, year = map(int, birth_date.split("-"))
    total = day + month + year

    while total > 9:
        total = sum(int(digit) for digit in str(total))

    return total


def get_lucky_number_description(lucky_number):
    descriptions = {
        1: "Your lucky number is 1. This number is often associated with leadership, independence, and determination.",
        2: "Your lucky number is 2. This number is associated with balance, harmony, and cooperation.",
        3: "Your lucky number is 3. This number is known for creativity, expression, and social interactions.",
        4: "Your lucky number is 4. This number is associated with stability, hard work, and practicality.",
        5: "Your lucky number is 5. This number is known for adventure, freedom, and change.",
        6: "Your lucky number is 6. This number is associated with nurturing, family, and harmony.",
        7: "Your lucky number is 7. This number is known for spirituality, intuition, and introspection.",
        8: "Your lucky number is 8. This number is associated with success, abundance, and material achievements.",
        9: "Your lucky number is 9. This number is known for compassion, healing, and spiritual growth.",
    }

    return descriptions.get(lucky_number, "Your lucky number is not defined.")


@app.route("/", methods=["GET", "POST"])
def lucky_number():
    print(request.form)  # Print the form data for debugging

    description = ""
    cultural_practices = ""
    name = ""
    lucky_number = 0  # Initialize lucky_number with a default value

    if request.method == "POST":
        name = request.form["name"]
        day = int(request.form["day"])
        month = int(request.form["month"])
        year = int(request.form["year"])

        birth_date = f"{year:04d}-{month:02d}-{day:02d}"
        lucky_number = calculate_lucky_number(birth_date)
        print("Lucky Number:", lucky_number)  # Add this line
        description = get_lucky_number_description(lucky_number)

        if lucky_number == 8:
            cultural_practices = "In some cultures, the number 8 is considered extremely lucky and is associated with wealth and prosperity."
        elif lucky_number == 9:
            cultural_practices = "Number 9 is considered lucky in many cultures and is associated with longevity and spiritual growth."

    translations = {
        "lucky_number_text": "Today will be a good day for you",
        "good_day_message": "ఈ రోజు మీకు మంచి రోజు అవుతుంది",
    }
    print("Calculated Lucky Number:", lucky_number)  # Add this line
    return render_template(
        "index.html",
        name=name,
        description=description,
        cultural_practices=cultural_practices,
        lucky_number=lucky_number,
        translations=translations,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
