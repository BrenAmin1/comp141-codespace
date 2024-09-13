
/*
* Teran Upchurch, Brendon Amino, Joao Engel   
*                  9/11/24								     
* 	Checks if an input follows the rules        
*      	of the regex defined below		         
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

string menu(){
	string userInput;
	cout << "Enter a statement (or 'X' to termiante the program): ";
	getline(cin, userInput);  // To capture the full input including spaces
	return userInput;
}

vector<string> tokenizer(string str) {
	stringstream ss(str);
	string word;
	vector<string> words;
	while (ss >> word) {
		words.push_back(word);
	}
	return words;
}

bool isNumber(string str) {
	regex numberPattern("[0-9]+");
	return regex_match(str, numberPattern);
}

bool isVariable(string str) {
	regex variablePattern("(_|[a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)*");
	return regex_match(str, variablePattern);
}

bool isOperator(string str) {
	regex opPattern("([+]|[-]|[*]|[/])");
	return regex_match(str, opPattern);
}

pair<string, string> isValidToken(string str) {
	pair<string,string> assignedToken;
	if (isNumber(str)) {
		assignedToken = make_pair("number", str);
	}
	else if (isVariable(str)) {
		assignedToken = make_pair("variable", str);
	}
	else if (isOperator(str)) {
		assignedToken = make_pair("operator", str);
	}
	else if (str == "=") {
		assignedToken = make_pair("eq", str);
	}
	else {
		assignedToken = make_pair("INVALID", str); //Checks for special chars
	}
	return assignedToken;
}

// Checks if matches A Eq A Op A.
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

// Checks if each of 5 tokens are in a valid location, does not check if equation valid.
bool isValidStatement(vector<pair<string,string>> vec) {
	if (vec.size() != 5) {
		cout << "Syntax Error: Expected 5 tokens but found " << vec.size() << endl;
		return false;
	}
	if (vec.at(0).first != "number" && vec.at(0).first != "variable") {
		cout << "Syntax Error: Expected a number or variable first, but found " << vec[0].second << endl;
		return false;
	}
	if (vec.at(1).first != "eq" && vec.at(3).first != "eq") {
		cout << "Syntax Error: Expected an eq" << endl;
		return false;
	}
	if (vec.at(1).first != "operator" && vec.at(3).first != "operator") {
		cout << "Syntax Error: Expected an operator" << endl;	
		return false;
	}
	if (vec.at(2).first != "number" && vec.at(2).first != "variable") {
		cout << "Syntax Error: Expected a number or variable third, but found " << vec[0].second << endl;	
		return false;
	}
	if (vec.at(4).first != "number" && vec.at(4).first != "variable") {
		cout << "Syntax Error: Expected a number or variable fifth, but found " << vec[0].second << endl;
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

void solveEquation(vector<pair<string,string>> vec, bool secState) {
	//check op
	//check var if any

	vector<int> varPos;
	// position of variables in the vector
	varPos = howManyVarAndWhere(vec);
		if (varPos.size() > 1){
			cout << "Unsolvable" << endl;
			return;
		}

	cout << "varPose: " << varPos.size() << endl;
	// A Eq A Op A
	if (secState) {
		// number = number Op number
		if (varPos.size() == 0){
			int leftValue = stoi(vec[0].second);
			int opLeft = stoi(vec[2].second);
			int opRight = stoi(vec[4].second);
			char op = vec[3].second[0];
			int result;
	
			switch (op) {
				case '+':
					result = opLeft + opRight;
					break;
				case '-':
					result = opLeft - opRight;
					break;
				case '*':
					result = opLeft * opRight;
					break;
				case '/':
					result = opLeft / opRight;
					break;
			}
	
			if (leftValue == result) {
				cout << "True Statement" << endl;
			} else {
				cout << "Invalid Statement" << endl;
			}
			return; // not sure if I should return it here
		}

		string leftValue = vec[0].second;
		string opLeft = vec[2].second;
		string opRight = vec[4].second;
		char op = vec[3].second[0];
		int result;
		
		if (varPos[0] == 0) {

			switch (op) {
				case '+':
					result = stoi(opLeft) + stoi(opRight);
					break;
				case '-':
					result = stoi(opLeft) - stoi(opRight);
					break;
				case '*':
					result = stoi(opLeft) * stoi(opRight);
					break;
				case '/':
					result = stoi(opLeft) / stoi(opRight);
					break;
			}
			cout << leftValue << " is " << result << endl;
		}

		if (varPos[0] == 2) {

			switch (op) {
				case '+':
					result = stoi(leftValue) - stoi(opRight);
					break;
				case '-':
					result = stoi(leftValue) + stoi(opRight);
					break;
				case '*':
					result = stoi(leftValue) / stoi(opRight);
					break;
				case '/':
					result = stoi(leftValue) * stoi(opRight);
					break;
			}
			cout << opLeft << " is " << result << endl;
		}

		if (varPos[0] == 4) {

			switch (op) {
				case '+':
					result = stoi(leftValue) - stoi(opLeft);
					break;
				case '-':
					result = stoi(opLeft) - stoi(leftValue);
					break;
				case '*':
					result = stoi(leftValue) / stoi(opLeft);
					break;
				case '/':
					result = stoi(opLeft) / stoi(leftValue);
					break;
			}
			cout << opRight << " is " << result << endl;
		}
}
// number Op number = number
	if (varPos.size() == 0){
		int rightValue = stoi(vec[4].second);
		int opLeft = stoi(vec[0].second);
		int opRight = stoi(vec[2].second);
		char op = vec[1].second[0];
		int result;
	
		switch (op) {
			case '+':
				result = opLeft + opRight;
				break;
			case '-':
				result = opLeft - opRight;
				break;
			case '*':
				result = opLeft * opRight;
				break;
			case '/':
				result = opLeft / opRight;
				break;
		}
	
		if (rightValue == result) {
			cout << "True Statement" << endl;
		} else {
			cout << "Invalid Statement" << endl;
		}
		return;
	}

	string rightValue = vec[4].second;
	string opLeft = vec[0].second;
	string opRight = vec[2].second;
	char op = vec[1].second[0];
	int result;

	if (varPos[0] == 0) {
		switch (op) {
			case '+':
				result = stoi(rightValue) - stoi(opRight);
				break;
			case '-':
				result = stoi(rightValue) + stoi(opRight);
				break;
			case '*':
				result = stoi(rightValue) / stoi(opRight);
				break;
			case '/':
				result = stoi(rightValue) * stoi(opRight);
				break;
		}
		cout << opLeft << " is " << result << endl;
		return;
	}

	if (varPos[0] == 2) {
		switch (op) {
			case '+':
				result = stoi(rightValue) - stoi(opLeft);
				break;
			case '-':
				result = stoi(opLeft) - stoi(rightValue);
				break;
			case '*':
				result = stoi(rightValue) / stoi(opLeft);
				break;
			case '/':
				result = stoi(opLeft) / stoi(rightValue);
				break;
		}
		cout << opRight << " is " << result << endl;
		return;
	}

	if (varPos[0] == 4) {
		switch (op) {
			case '+':
				result = stoi(opLeft) + stoi(opRight);
				break;
			case '-':
				result = stoi(opLeft) - stoi(opRight);
				break;
			case '*':
				result = stoi(opLeft) * stoi(opRight);
				break;
			case '/':
				result = stoi(opLeft) / stoi(opRight);
				break;
		}
		cout << rightValue << " is " << result << endl;
		return;
	}
	
	return ;
}

int main() {
	string userInput;
	
	while (true) {
		userInput = menu();
		if (userInput == "x" || userInput == "X") {
			break;
		};
		string dummy = "Rabbit + 8 + Cat";
		vector<string> tokens = tokenizer(userInput);
		bool isSecondStatement;
		//bool isStatementSolvable;
		vector<pair<string,string>> validTokens;
		for (string token : tokens) {
			validTokens.push_back(isValidToken(token));
		};

		if (!isValidStatement(validTokens)) {
			continue; // if state is not valid, prompt user again for new statement
		};

		// checking if it matches `A Eq A Op A`
		isSecondStatement = matchSecondStatement(validTokens);

		solveEquation(validTokens, isSecondStatement);

		// 	for(pair<string, string>token : validTokens) {
		// 		cout << token.first << " " << token.second << endl;
		// 	};
		cout << "\n\n"; // not sure if this is the right way of adding an extra line at the end
	}


	return 0;
}
