#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <sstream>

using namespace std;

void dfs(
    const string& node,
    unordered_map<string, vector<string>>& adj,
    unordered_set<string>& visited,
    bool& first
) {
    visited.insert(node);

    if (!first) {
        cout << " ";
    }

    cout << node;
    first = false;

    for (const string& neighbor : adj[node]) {
        if (!visited.count(neighbor)) {
            dfs(neighbor, adj, visited, first);
        }
    }
}

int main() {
    int numInst;
    cin >> numInst;

    while (numInst--) {
        vector<string> nodeOrder;
        unordered_map<string, vector<string>> adj;

        int numNode;
        cin >> numNode;
        cin.ignore();

        while (numNode--) {
            string line;
            getline(cin, line);

            stringstream ss(line);

            string node;
            ss >> node;

            nodeOrder.push_back(node);

            string neighbor;
            while (ss >> neighbor) {
                adj[node].push_back(neighbor);
            }
        }

        unordered_set<string> visited;

        bool first = true;

        for (const string& node : nodeOrder) {
            if (!visited.count(node)) {
                dfs(node, adj, visited, first);
            }
        }

        cout << "\n";
    }
}
