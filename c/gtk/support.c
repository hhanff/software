/* support.c
 *
 * Copyright (C) 2006 Juan José Gago Martínez <juanj_gama@hotmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

#include <gnome.h>
#include <gtksourceview/gtksourcelanguage.h>
#include <gtksourceview/gtksourcelanguagesmanager.h>

#include "support.h"
#include "log.h"

GtkWidget *
lookup_widget (GtkWidget * widget, const gchar * widget_name)
{
	GtkWidget *parent, *found_widget;

	for (;;)
	{
		if (GTK_IS_MENU (widget))
			parent = gtk_menu_get_attach_widget (GTK_MENU
							     (widget));
		else
			parent = widget->parent;
		if (!parent)
			parent = (GtkWidget *)
				g_object_get_data (G_OBJECT (widget),
						   "GladeParentKey");
		if (parent == NULL)
			break;
		widget = parent;
	}

	found_widget = (GtkWidget *) g_object_get_data (G_OBJECT (widget),
							widget_name);
	if (!found_widget)
		g_warning ("Widget not found: %s", widget_name);
	return found_widget;
}

/*
 * This is an internally used function to create pixmaps. 
 */
GtkWidget *
create_pixmap (GtkWidget * widget, const gchar * filename)
{
	GtkWidget *pixmap;
	gchar *pathname;

	if (!filename || !filename[0])
		return gtk_image_new ();

	pathname =
		gnome_program_locate_file (NULL, GNOME_FILE_DOMAIN_APP_PIXMAP,
					   filename, TRUE, NULL);
	if (!pathname)
	{
		g_warning (_("Can not find pixmap file: \"%s\""), filename);
		return gtk_image_new ();
	}

	pixmap = gtk_image_new_from_file (pathname);
	g_free (pathname);
	return pixmap;
}

/*
 * This is an internally used function to create pixbufs. 
 */
GdkPixbuf *
create_pixbuf (const gchar * filename)
{
	gchar *pathname = NULL;
	GdkPixbuf *pixbuf;
	GError *error = NULL;

	if (!filename || !filename[0])
		return NULL;

	pathname =
		gnome_program_locate_file (gnome_program_get (),
					   GNOME_FILE_DOMAIN_APP_PIXMAP,
					   filename, TRUE, NULL);

	if (!pathname)
	{
		g_warning (_("Can not find pixmap file: \"%s\""), filename);
		return NULL;
	}

	pixbuf = gdk_pixbuf_new_from_file (pathname, &error);
	if (!pixbuf)
	{
		fprintf (stderr,
			 _("Can not load pixbuf file: \"%s\": %s"),
			 pathname, error->message);
		g_error_free (error);
	}
	g_free (pathname);
	return pixbuf;
}

/*
 * This is used to set ATK action descriptions. 
 */
void
glade_set_atk_action_description (AtkAction * action,
				  const gchar * action_name,
				  const gchar * description)
{
	gint n_actions, i;

	n_actions = atk_action_get_n_actions (action);
	for (i = 0; i < n_actions; i++)
	{
		if (!strcmp (atk_action_get_name (action, i), action_name))
			atk_action_set_description (action, i, description);
	}
}

gchar *
glp_solve_add_extension (gchar * path, gchar * ext)
{
	gchar *name = NULL;

	name = g_path_get_basename (path);

	if (strlen (name) > 0)
	{
		if (!g_str_has_suffix (name, ext))
			name = g_strdup_printf ("%s%s", name, ext);
	}

	return name;
}

GdkPixbuf *
glp_solve_get_logo_pixbuf ()
{
	GdkPixbuf *logo_pixbuf;
	logo_pixbuf = create_pixbuf ("GLP-Solve/glp-solve-icon.png");
	if (logo_pixbuf == NULL)
		g_warning (_("Error loading application icon"));
	return logo_pixbuf;
}

void
glp_solve_set_window_logo (GtkWindow * window, GdkPixbuf * logo)
{
	g_assert (window != NULL);
	if (logo == NULL)
	{
		g_warning (_("Error setting window icon"));
		return;
	}
	gtk_window_set_icon (window, logo);
}
