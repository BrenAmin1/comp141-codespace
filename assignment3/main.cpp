/*
 * Teran Upchurch, Brendon Amino, Joao Engel  
 * DATE: 9/11/24      
 *
 * Checks if an input follows the rules        
 * of the regex defined below and prints out whether if its
 * syntactically valid, solvable, and true. 
 * If there’s a variable, it then solves for the variable.
 * Otherwise, print an error message.
 * Only works with whole numbers.
 */
#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <regex>
#include <utility>
#include <cstdlib>
#include <cmath>
using namespace std;

// prompts user, asks for a input(statement), and stores it
string menu() {
    string userInput;
    cout << "Enter a statement (or 'X' to termiante the program): ";
    getline(cin, userInput);  // To capture the full input including spaces
    return userInput;
}

// breaks user input into smaller pieces named tokens
vector<string> tokenizer(string str) {
    stringstream ss(str);
    string word = "";
    vector<string> words;
    while (ss >> word) {
        words.push_back(word);
    }
    return words;
}

// checks if input is a valid "number"
bool isNumber(string str) {
    regex numberPattern("[0-9]+");
    return regex_match(str, numberPattern);
}

// checks if input is a valid string
bool isVariable(string str) {
    regex variablePattern("(_|[a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)*");
    return regex_match(str, variablePattern);
}

// checks if input is a valid operator
bool isOperator(string str) {
    regex opPattern("([+]|[-]|[*]|[/])");
    return regex_match(str, opPattern);
}

// checks if token is valid, then creates and inserts pairs containing the token's type and value to a vector
pair<string, string> isValidToken(string str) {
    pair<string,string> assignedToken;
    if (isNumber(str)){
        assignedToken = make_pair("number", str);
    } else if (isVariable(str)) {
        assignedToken = make_pair("variable", str);
    } else if (isOperator(str)) {
        assignedToken = make_pair("operator", str);
    } else if (str == "=") {
        assignedToken = make_pair("eq", str);
    } else {
        assignedToken = make_pair("INVALID", str); //Checks for special chars
    }
    return assignedToken;
}


// Checks if matches A Eq A Op A pattern.
bool matchSecondStatement(vector<pair<string,string>> vec) {
    if ((vec[0].first == "number" || vec[0].first == "variable")
        && vec[1].first == "eq"
        && (vec[2].first == "number" || vec[2].first == "variable")
        && vec[3].first == "operator"
        && (vec[4].first == "number" || vec[4].first == "variable")) {
        return true;
    }
    return false;
}

// Checks if each of 5 tokens are in a valid location; does not check if the equation is valid.
bool isValidStatement(vector<pair<string,string>> vec) {
    if (vec.size() != 5) {
        cout << "Syntax Error: Expected 5 tokens but found " << vec.size() << endl;
        return false;
    }
    if (vec.at(0).first != "number" && vec.at(0).first != "variable") {
        cout << "Syntax Error: Expected a number or variable in the first position, but found " << vec[0].second << endl;
        return false;
    }
    if (vec.at(1).first != "eq" && vec.at(3).first != "eq") {
        cout << "Syntax Error: Expected an equal sign" << endl;
        return false;
    }
    if (vec.at(1).first != "operator" && vec.at(3).first != "operator") {
        cout << "Syntax Error: Expected an operator" << endl;  
        return false;
    }
    if (vec.at(2).first != "number" && vec.at(2).first != "variable") {
        cout << "Syntax Error: Expected a number or variable in the third position, but found " << vec[2].second << endl;  
        return false;
    }
    if (vec.at(4).first != "number" && vec.at(4).first != "variable") {
        cout << "Syntax Error: Expected a number or variable in the fifth position, but found " << vec[4].second << endl;
        return false;
    }
    cout << "Syntactically Valid" << endl;
    return true;
}

// locating the variable placement
vector<int> howManyVarAndWhere(vector<pair<string,string>> vec){
    vector<int> variableIndices; // Stores indices where "variable" occurs
   
    // Iterate over the vector of pairs
    for (int i = 0; i < vec.size(); ++i) {
        if (vec[i].first == "variable") { // Check if pair.first == "variable"
            variableIndices.push_back(i); // Store index of "variable"
        }
    }
    return variableIndices;
}

// Returns the value of the equation based on Op position. Works w/ and w/o variable.
int basicEquation(string opLeft, string opRight, char op) {
    int result = 0;
    switch (op) {
        case '+':
            result = stoi(opLeft) + stod(opRight);
            break;
        case '-':
            result = stoi(opLeft) - stod(opRight);
            break;
        case '*':
            result = stoi(opLeft) * stod(opRight);
            break;
        case '/':
            result = stoi(opLeft) / stod(opRight);
            break;
    };
    return result;
};

// works with equations where the variable is inside the expression and located to the right of the operator
int resultOpRight(string resultExpression, string opRight, char op) {
    int result = 0;
    switch (op) {
        case '+':
            result = stoi(resultExpression) - stod(opRight);
            break;
        case '-':
            result = stoi(resultExpression) + stod(opRight);
            break;
        case '*':
            result = stoi(resultExpression) / stod(opRight);
            break;
        case '/':
            result = stoi(resultExpression) * stod(opRight);
            break;
    }
    return result;
}

// works with equations where the variable is inside the expression and located to the left of the operator
int resultOpLeft(string resultExpression, string opLeft, char op) {
    int result = 0;
    switch (op) {
        case '+':
            result = stoi(resultExpression) - stod(opLeft);
            break;
        case '-':
            result = stoi(opLeft) - stod(resultExpression);
            break;
        case '*':
            result = stoi(resultExpression) / stod(opLeft);
            break;
        case '/':
            result = stoi(opLeft) / stod(resultExpression);
            break;
    }
    return result;
}

// Checks if Equation is solvable, then determines which type of Equation it is.
void solveEquation(vector<pair<string,string>> vec, bool secState) {
    vector<int> varPos; // Position of variables in the vector
    varPos = howManyVarAndWhere(vec);
        if (varPos.size() > 1) { // Returns if there's more than 1 variable
            cout << "Unsolvable" << endl;
            return;
        }

    // Checks for A Eq A Op A
    if (secState) {
        string leftValue = vec[0].second;
        string opLeft = vec[2].second;
        string opRight = vec[4].second;
        char op = vec[3].second[0];
        int result = 0;
        
        // number = number Op number
        if (varPos.size() == 0) {
            result = basicEquation(opLeft, opRight, op);
            if (stoi(leftValue) == result) {
                cout << "True Statement" << endl;
            } else {
                cout << "Invalid Statement" << endl;
            }
            return; // Must return here else seg faults
        }
        
        // Checks variable position, solves, then prints result and returns.
        if (varPos[0] == 0) { // Variable Eq Num Op Num
            result = basicEquation(opLeft, opRight, op);
            cout << leftValue << " is " << result << endl;
            return;
        }
        if (varPos[0] == 2) { // Num Eq Variable Op Num
            result = resultOpRight(leftValue, opRight, op);
            cout << opLeft << " is " << result << endl;
            return;
        }
        if (varPos[0] == 4) { // Num Eq Num Op Variable
            result = resultOpLeft(leftValue, opLeft, op);
            cout << opRight << " is " << result << endl;
            return;
        }
    }

    string rightValue = vec[4].second;
    string opLeft = vec[0].second;
    string opRight = vec[2].second;
    char op = vec[1].second[0];
    int result = 0;
    
    // Checks for A Op A Eq A
    if (varPos.size() == 0) {  // number Op number = number
        result = basicEquation(opLeft, opRight, op);
        if (stoi(rightValue) == result) {
            cout << "True Statement" << endl;
        } else {
            cout << "Invalid Statement" << endl;
        }
        return;
    }
    
    // Checks variable position, solves, then prints result and returns.
    if (varPos[0] == 0) { // Variable Op Num Eq Num
        result = resultOpRight(rightValue, opRight, op);
        cout << opLeft << " is " << result << endl;
        return;
    }
    if (varPos[0] == 2) { // Num Op Variable Eq Num
        result = resultOpLeft(rightValue, opLeft, op);
        cout << opRight << " is " << result << endl;
        return;
    }
    if (varPos[0] == 4) { // Num Op Num Eq Variable
        result = basicEquation(opLeft, opRight, op);
        cout << rightValue << " is " << result << endl;
        return;
    }
    
    return;
}

int main() {
    string userInput;
    
    // Main program loop
    while (true) {
        userInput = menu();
        if (userInput == "x" || userInput == "X") { // Exit Condition
            break;
        };
        
        vector<string> tokens = tokenizer(userInput);
        bool isSecondStatement;
        vector<pair<string,string>> validTokens;
        
        for (string token : tokens) {
            validTokens.push_back(isValidToken(token));
        };
        if (!isValidStatement(validTokens)) {
            cout << "\n" << endl;
            continue; // if state is not valid, prompt user again for new statement
        };

        // checking if it matches `A Eq A Op A`
        isSecondStatement = matchSecondStatement(validTokens);
        
        solveEquation(validTokens, isSecondStatement);
        cout << "\n" << endl; // Flushes buffer
    }

    return 0;
}
