









































import java.awt.Dimension;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;


import javax.swing.JPanel;

import javax.swing.JTree;

import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.text.AttributeSet;
import javax.swing.text.Document;
import javax.swing.text.Element;
import javax.swing.text.JTextComponent;

import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;

import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;











public class ElementTreePanel extends JPanel implements CaretListener,
        DocumentListener, PropertyChangeListener, TreeSelectionListener {


    protected JTree tree;



    protected ElementTreeModel treeModel;




    public ElementTreePanel(JTextComponent editor) {






        tree = new JTree(treeModel) {


            public String convertValueToText(Object value, boolean selected,

                    int row, boolean hasFocus) {





                Element e = (Element) value;
                AttributeSet as = e.getAttributes().copyAttributes();
                String asString;

                if (as != null) {
                    StringBuilder retBuffer = new StringBuilder("[");













                    asString = retBuffer.toString();
                } else {
                    asString = "[ ]";





                }
                return e.getName() + " [" + e.getStartOffset() + ", " + e.
                        getEndOffset() + "] Attributes: " + asString;
            }
        };










        tree.setCellRenderer(new DefaultTreeCellRenderer() {


            public Dimension getPreferredSize() {
                Dimension retValue = super.getPreferredSize();



                return retValue;
            }
        });






















    }





































    public void propertyChange(PropertyChangeEvent e) {













    }








    public void insertUpdate(DocumentEvent e) {

    }








    public void removeUpdate(DocumentEvent e) {

    }






    public void changedUpdate(DocumentEvent e) {

    }






    public void caretUpdate(CaretEvent e) {











































    }






    public void valueChanged(TreeSelectionEvent e) {

















    }








































































































    protected TreePath getPathForIndex(int position, Object root,
            Element rootElement) {
        TreePath path = new TreePath(root);









        return path;
    }
















    public static class ElementTreeModel extends DefaultTreeModel {



        public ElementTreeModel(Document document) {
            super(new DefaultMutableTreeNode("root"), false);

































































































        }





        protected TreeNode[] getPathToRoot(TreeNode aNode, int depth) {
            TreeNode[] retNodes;



            if (aNode == null) {
                if (depth == 0) {
                    return null;
                } else {
                    retNodes = new TreeNode[depth];
                }
            } else {

                if (aNode == root) {
                    retNodes = new TreeNode[depth];
                } else {
                    TreeNode parent = aNode.getParent();




                    retNodes = getPathToRoot(parent, depth);
                }

            }
            return retNodes;
        }
    }
}
