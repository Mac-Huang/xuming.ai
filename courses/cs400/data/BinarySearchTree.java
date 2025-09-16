/**
 * CS 400: Programming III
 * Binary Search Tree Implementation with Rotation Support
 * University of Wisconsin-Madison
 *
 * Author: Xuming Huang
 *
 * This implementation provides a generic Binary Search Tree with support for:
 * - Insertion with duplicate handling (duplicates go to left subtree)
 * - Searching with O(log n) average time complexity
 * - Tree rotations for balancing operations
 * - Size calculation and empty checks
 */

public class BinarySearchTree<T extends Comparable<T>> implements SortedCollection<T> {
    protected BinaryNode<T> root;

    /**
     * Node class for the binary search tree
     */
    protected static class BinaryNode<T> {
        private T data;
        private BinaryNode<T> left;
        private BinaryNode<T> right;
        private BinaryNode<T> parent;

        public BinaryNode(T data) {
            this.data = data;
            this.left = null;
            this.right = null;
            this.parent = null;
        }

        public T getData() { return data; }
        public void setData(T data) { this.data = data; }

        public BinaryNode<T> getLeft() { return left; }
        public void setLeft(BinaryNode<T> left) { this.left = left; }

        public BinaryNode<T> getRight() { return right; }
        public void setRight(BinaryNode<T> right) { this.right = right; }

        public BinaryNode<T> getParent() { return parent; }
        public void setParent(BinaryNode<T> parent) { this.parent = parent; }

        public boolean isLeftChild() {
            return parent != null && parent.left == this;
        }

        public boolean isRightChild() {
            return parent != null && parent.right == this;
        }
    }

    /**
     * Constructs an empty binary search tree.
     */
    public BinarySearchTree() {
        root = null;
    }

    /**
     * Inserts a new data value into the sorted collection.
     * Duplicates are stored in the left subtree of a parent with an equal value.
     *
     * @param data the new value being inserted
     * @throws NullPointerException if data argument is null
     */
    @Override
    public void insert(T data) throws NullPointerException {
        if (data == null) {
            throw new NullPointerException("Cannot insert null data into BST");
        }

        BinaryNode<T> newNode = new BinaryNode<>(data);

        if (root == null) {
            root = newNode;
        } else {
            insertHelper(newNode, root);
        }
    }

    /**
     * Performs the naive binary search tree insert algorithm to recursively
     * insert the provided newNode into the provided tree/subtree.
     *
     * @param newNode the new node to insert into the tree
     * @param subtree the current subtree root to insert under
     */
    protected void insertHelper(BinaryNode<T> newNode, BinaryNode<T> subtree) {
        int comparison = newNode.getData().compareTo(subtree.getData());

        if (comparison <= 0) {
            // Insert to the left (including duplicates)
            if (subtree.getLeft() == null) {
                subtree.setLeft(newNode);
                newNode.setParent(subtree);
            } else {
                insertHelper(newNode, subtree.getLeft());
            }
        } else {
            // Insert to the right
            if (subtree.getRight() == null) {
                subtree.setRight(newNode);
                newNode.setParent(subtree);
            } else {
                insertHelper(newNode, subtree.getRight());
            }
        }
    }

    /**
     * Check whether data is stored in the tree.
     *
     * @param data the value to check for in the collection
     * @return true if the collection contains data one or more times
     * @throws NullPointerException if data argument is null
     */
    @Override
    public boolean contains(Comparable<T> data) throws NullPointerException {
        if (data == null) {
            throw new NullPointerException("Cannot search for null data in BST");
        }
        return containsHelper(root, data);
    }

    /**
     * Recursive helper method to search for a value in the tree.
     *
     * @param node the current node being examined
     * @param data the value to search for
     * @return true if the value is found, false otherwise
     */
    private boolean containsHelper(BinaryNode<T> node, Comparable<T> data) {
        if (node == null) {
            return false;
        }

        int comparison = data.compareTo(node.getData());

        if (comparison < 0) {
            return containsHelper(node.getLeft(), data);
        } else if (comparison > 0) {
            return containsHelper(node.getRight(), data);
        } else {
            return true; // Found the element
        }
    }

    /**
     * Counts the number of values in the collection.
     * Each duplicate value is counted separately.
     *
     * @return the number of values in the collection
     */
    @Override
    public int size() {
        return sizeHelper(root);
    }

    /**
     * Recursive helper method to count the number of nodes in the tree.
     *
     * @param node the root of the subtree to count
     * @return the number of nodes in the subtree
     */
    private int sizeHelper(BinaryNode<T> node) {
        if (node == null) {
            return 0;
        }

        // Count this node plus all nodes in left and right subtrees
        return 1 + sizeHelper(node.left) + sizeHelper(node.right);
    }

    /**
     * Checks if the collection is empty.
     *
     * @return true if the collection contains 0 values
     */
    @Override
    public boolean isEmpty() {
        return root == null;
    }

    /**
     * Removes all values and duplicates from the collection.
     */
    @Override
    public void clear() {
        // Java garbage collection will handle memory deallocation
        root = null;
    }

    /**
     * Performs a rotation operation on the tree.
     * This is a fundamental operation for tree balancing algorithms.
     *
     * @param child the child node to rotate up
     * @param parent the parent node to rotate down
     * @throws NullPointerException if either parameter is null
     * @throws IllegalArgumentException if nodes don't have parent-child relationship
     */
    protected void rotate(BinaryNode<T> child, BinaryNode<T> parent)
            throws NullPointerException, IllegalArgumentException {

        // Check if either passed argument is null
        if (child == null || parent == null) {
            throw new NullPointerException("Cannot rotate with null nodes");
        }

        // Check if they have a valid parent-child relationship
        if (child.getParent() != parent ||
            (parent.getLeft() != child && parent.getRight() != child)) {
            throw new IllegalArgumentException("Nodes must have parent-child relationship");
        }

        // Determine rotation direction
        boolean isLeftRotation = child.isRightChild();

        // Store grandparent reference
        BinaryNode<T> grandparent = parent.getParent();

        // Update child's parent to grandparent
        child.setParent(grandparent);

        // Update grandparent's child reference
        if (grandparent != null) {
            if (parent.isRightChild()) {
                grandparent.setRight(child);
            } else {
                grandparent.setLeft(child);
            }
        } else {
            // If no grandparent, child becomes new root
            this.root = child;
        }

        // Perform the rotation based on direction
        if (isLeftRotation) {
            // Left rotation (child is right child of parent)
            // Move child's left subtree to parent's right
            BinaryNode<T> childLeft = child.getLeft();
            parent.setRight(childLeft);
            if (childLeft != null) {
                childLeft.setParent(parent);
            }

            // Make parent the left child of child
            child.setLeft(parent);
            parent.setParent(child);
        } else {
            // Right rotation (child is left child of parent)
            // Move child's right subtree to parent's left
            BinaryNode<T> childRight = child.getRight();
            parent.setLeft(childRight);
            if (childRight != null) {
                childRight.setParent(parent);
            }

            // Make parent the right child of child
            child.setRight(parent);
            parent.setParent(child);
        }
    }

    /**
     * Get the height of the tree.
     *
     * @return the height of the tree (0 for empty tree)
     */
    public int height() {
        return heightHelper(root);
    }

    /**
     * Recursive helper to calculate tree height.
     *
     * @param node the root of the subtree
     * @return the height of the subtree
     */
    private int heightHelper(BinaryNode<T> node) {
        if (node == null) {
            return 0;
        }

        int leftHeight = heightHelper(node.getLeft());
        int rightHeight = heightHelper(node.getRight());

        return 1 + Math.max(leftHeight, rightHeight);
    }

    /**
     * In-order traversal of the tree (for testing/debugging).
     *
     * @return a string representation of the tree in sorted order
     */
    public String inOrderTraversal() {
        StringBuilder result = new StringBuilder();
        inOrderHelper(root, result);
        return result.toString().trim();
    }

    /**
     * Recursive helper for in-order traversal.
     *
     * @param node current node
     * @param result string builder to accumulate results
     */
    private void inOrderHelper(BinaryNode<T> node, StringBuilder result) {
        if (node != null) {
            inOrderHelper(node.getLeft(), result);
            result.append(node.getData()).append(" ");
            inOrderHelper(node.getRight(), result);
        }
    }

    /**
     * Find the minimum value in the tree.
     *
     * @return the minimum value, or null if tree is empty
     */
    public T findMin() {
        if (root == null) {
            return null;
        }

        BinaryNode<T> current = root;
        while (current.getLeft() != null) {
            current = current.getLeft();
        }

        return current.getData();
    }

    /**
     * Find the maximum value in the tree.
     *
     * @return the maximum value, or null if tree is empty
     */
    public T findMax() {
        if (root == null) {
            return null;
        }

        BinaryNode<T> current = root;
        while (current.getRight() != null) {
            current = current.getRight();
        }

        return current.getData();
    }
}