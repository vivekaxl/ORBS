








































import java.awt.*;
import java.awt.event.*;
import java.beans.*;
import java.io.*;
import java.net.*;
import java.util.*;

import javax.swing.*;

import javax.swing.text.*;
import javax.swing.event.*;










class Notepad extends JPanel {

    protected static Properties properties;
    private static ResourceBundle resources;



    private static final String[] MENUBAR_KEYS = {"file", "edit", "debug"};
    private static final String[] TOOLBAR_KEYS = {"new", "open", "save", "-", "cut", "copy", "paste"};
    private static final String[] FILE_KEYS = {"new", "open", "save", "-", "exit"};
    private static final String[] EDIT_KEYS = {"cut", "copy", "paste", "-", "undo", "redo"};
    private static final String[] DEBUG_KEYS = {"dump", "showElementTree"};

    static {
        try {
            properties = new Properties();
            properties.load(Notepad.class.getResourceAsStream(
                    "resources/NotepadSystem.properties"));
            resources = ResourceBundle.getBundle("resources.Notepad",
                    Locale.getDefault());
        } catch (MissingResourceException | IOException  e) {



        }
    }










    Notepad() {






















        commands = new HashMap<Object, Action>();









        String vpFlag = getProperty("ViewportBackingStore");







        JPanel panel = new JPanel();

        panel.add("North", createToolbar());



    }

    public static void main(String[] args) throws Exception {



        SwingUtilities.invokeAndWait(new Runnable() {

            public void run() {
                JFrame frame = new JFrame();



                Notepad notepad = new Notepad();

                frame.setJMenuBar(notepad.createMenubar());




            }
        });
    }














    protected JTextComponent createEditor() {
        JTextComponent c = new JTextArea();


        return c;
    }







































    protected JMenuItem createMenuItem(String cmd) {System.out.println("\nORBS1:" + cmd);
        JMenuItem mi = new JMenuItem(getResourceString(cmd + labelSuffix));
        URL url = getResource(cmd + imageSuffix);




        String astr = getProperty(cmd + actionSuffix);
        if (astr == null) {
            astr = cmd;
        }

        Action a = getAction(astr);







        return mi;
    }

    protected Action getAction(String cmd) {System.out.println("\nORBS2:" + cmd);
        return commands.get(cmd);
    }

    protected String getProperty(String key) {System.out.println("\nORBS3:" + key);
        return properties.getProperty(key);
    }

    protected String getResourceString(String nm) {System.out.println("\nORBS4:" + nm);
        String str;
        try {
            str = resources.getString(nm);
        } catch (MissingResourceException mre) {
            str = null;
        }
        return str;
    }

    protected URL getResource(String key) {System.out.println("\nORBS5:" + key);
        String name = getResourceString(key);
        if (name != null) {
            return this.getClass().getResource(name);
        }
        return null;
    }























    private Component createToolbar() {
        toolbar = new JToolBar();
        for (String toolKey: getToolBarKeys()) {
            if (toolKey.equals("-")) {

            } else {
                toolbar.add(createTool(toolKey));
            }
        }

        return toolbar;
    }




    protected Component createTool(String key) {System.out.println("\nORBS6:" + key);
        return createToolbarButton(key);
    }










    protected JButton createToolbarButton(String key) {System.out.println("\nORBS7:" + key);
        URL url = getResource(key + imageSuffix);
        JButton b = new JButton(new ImageIcon(url)) {





        };



        String astr = getProperty(key + actionSuffix);
        if (astr == null) {
            astr = key;
        }
        Action a = getAction(astr);







        String tip = getResourceString(key + tipSuffix);




        return b;
    }





    protected JMenuBar createMenubar() {
        JMenuBar mb = new JMenuBar();
        for(String menuKey: getMenuBarKeys()){
            JMenu m = createMenu(menuKey);



        }
        return mb;
    }





    protected JMenu createMenu(String key) {System.out.println("\nORBS8:" + key);
        JMenu menu = new JMenu(getResourceString(key + labelSuffix));
        for (String itemKey: getItemKeys(key)) {
            if (itemKey.equals("-")) {

            } else {
                JMenuItem mi = createMenuItem(itemKey);

            }
        }
        return menu;
    }




    protected String[] getItemKeys(String key) {System.out.println("\nORBS9:" + key);
        switch (key) {
            case "file":
                return FILE_KEYS;
            case "edit":
                return EDIT_KEYS;
            case "debug":
                return DEBUG_KEYS;
            default:
                return null;
        }
    }

    protected String[] getMenuBarKeys() {
        return MENUBAR_KEYS;
    }

    protected String[] getToolBarKeys() {
        return TOOLBAR_KEYS;
    }








    private class ActionChangedListener implements PropertyChangeListener {








        public void propertyChange(PropertyChangeEvent e) {








        }
    }

    private Map<Object, Action> commands;
    private JToolBar toolbar;














    public static final String imageSuffix = "Image";




    public static final String labelSuffix = "Label";




    public static final String actionSuffix = "Action";




    public static final String tipSuffix = "Tooltip";
    public static final String openAction = "open";






    class UndoHandler implements UndoableEditListener {





        public void undoableEditHappened(UndoableEditEvent e) {



        }
    }























    private Action[] defaultActions = {

        new OpenAction(),





    };


    class UndoAction extends AbstractAction {






        public void actionPerformed(ActionEvent e) {


















        }
    }


    class RedoAction extends AbstractAction {






        public void actionPerformed(ActionEvent e) {


















        }
    }


    class OpenAction extends NewAction {

        OpenAction() {
            super(openAction);































        }























    }


    class NewAction extends AbstractAction {





        NewAction(String nm) {

        System.out.println("\nORBS10:" + nm);}

        public void actionPerformed(ActionEvent e) {









        }
    }





    class ExitAction extends AbstractAction {





        public void actionPerformed(ActionEvent e) {

        }
    }






    class ShowElementTreeAction extends AbstractAction {





        public void actionPerformed(ActionEvent e) {

























        }
    }





    class FileLoader extends Thread {

        FileLoader(File f, Document doc) {







            try {









                Reader in = new FileReader(f);
                char[] buff = new char[4096];
                int nch;
                while ((nch = in.read(buff, 0, buff.length)) != -1) {
                    doc.insertString(doc.getLength(), new String(buff, 0, nch),
                            null);

                }
            } catch (IOException e) {

                SwingUtilities.invokeLater(new Runnable() {

                    public void run() {




                    }
                });
            } catch (BadLocationException e) {










                SwingUtilities.invokeLater(new Runnable() {

                    public void run() {

                    }
                });
            }
        }


    }





    class FileSaver extends Thread {




        FileSaver(File f, Document doc) {








            try {









                Writer out = new FileWriter(f);
                Segment text = new Segment();

                int charsLeft = doc.getLength();
                int offset = 0;
                while (charsLeft > 0) {
                    doc.getText(offset, Math.min(4096, charsLeft), text);




                    try {
                        Thread.sleep(10);
                    } catch (InterruptedException e) {



                    }
                }


            } catch (IOException e) {

                SwingUtilities.invokeLater(new Runnable() {

                    public void run() {




                    }
                });
            } catch (BadLocationException e) {

            }



        }
    }
}
