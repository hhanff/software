
#include <gtk/gtk.h>

#include <stdio.h>

 

void button_geklickt(GtkWidget *button_widget, gpointer data) {

    printf("Button \"%s\" geklickt!\n",

       gtk_button_get_label(GTK_BUTTON(button_widget)) );

    gtk_main_quit();

}

 

int main (int argc, char *argv[]) {

    gtk_init(&argc, &argv);

 

    GtkWidget *window;

    GtkWidget *button;

 

    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);

    gtk_window_set_title(GTK_WINDOW(window), "Hallo Welt!");

    gtk_container_set_border_width(GTK_CONTAINER(window), 10);

    g_signal_connect_swapped(G_OBJECT(window), "destroy", G_CALLBACK (gtk_main_quit), NULL);

 

    button = gtk_button_new_with_label("Hallo Wikipedia!");

    g_signal_connect(G_OBJECT(button), "clicked", G_CALLBACK(button_geklickt), NULL);

    gtk_widget_show(button);

 

    gtk_container_add(GTK_CONTAINER(window), button);

    gtk_widget_show(window);

 

    gtk_main();

    return 0;
