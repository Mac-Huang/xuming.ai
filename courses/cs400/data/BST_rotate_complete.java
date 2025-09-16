/**
 * Complete implementation of the BST rotate method for CS 400: Programming III
 * This method performs tree rotations for balancing operations
 */
protected void rotate(BinaryNode<T> child, BinaryNode<T> parent)
        throws NullPointerException, IllegalArgumentException {
    // Check if either passed argument is null
    if (child == null || parent == null) {
        throw new NullPointerException("Cannot rotate with null nodes");
    }

    // Check if they are legal family (parent-child relationship)
    if (child.getParent() != parent || (parent.getLeft() != child && parent.getRight() != child)) {
        throw new IllegalArgumentException("Nodes must have parent-child relationship");
    }

    // Determine rotation direction: true = left rotation, false = right rotation
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