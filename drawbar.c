void
drawbar(Monitor *m)
{
	int x, w, tw = 0;
	int boxs = m->drw->font->height / 9;
	int boxw = m->drw->font->height / 6 + 2;
	uint32_t i, occ = 0, urg = 0;
	Client *c;
	Buffer *buf;

	if (!m->scene_buffer->node.enabled)
		return;
	if (!(buf = bufmon(m)))
		return;

	/* draw status first so it can be overdrawn by tags later */
  if (m == selmon) {
        int status_width = 0;
        int curr_x;
        
        // Gesamtbreite für alle Skript-Outputs berechnen
        for (size_t i = 0; i < LENGTH(custom_scripts); i++) {
            if (i > 0) status_width += TEXTW(m, " "); // Leerzeichen zwischen Segmenten
            status_width += TEXTW(m, custom_scripts[i].output);
        }
        
        tw = status_width + 2; // +2 für padding
        curr_x = m->b.width - tw;
        
        // Jeden Skript-Output rendern
        for (size_t i = 0; i < LENGTH(custom_scripts); i++) {
            // Setze die Farbe für dieses Skript
            uint32_t scheme[] = {
                custom_scripts[i].color,           // Textfarbe
                colors[SchemeNorm][ColBg],        // Hintergrund
                colors[SchemeNorm][ColBorder]     // Rahmen
            };
            drwl_setscheme(m->drw, scheme);
            
            // Leerzeichen zwischen Segmenten
            if (i > 0) {
                drwl_text(m->drw, curr_x, 0, 
                         TEXTW(m, " "), m->b.height, 
                         0, " ", 0);
                curr_x += TEXTW(m, " ");
            }
            
            // Skript-Output rendern
            int width = TEXTW(m, custom_scripts[i].output);
            drwl_text(m->drw, curr_x, 0, width, m->b.height, 
                     0, custom_scripts[i].output, 0);
            curr_x += width;
        }
    }

	wl_list_for_each(c, &clients, link) {
		if (c->mon != m)
			continue;
		occ |= c->tags;
		if (c->isurgent)
			urg |= c->tags;
	}
	x = 0;
	c = focustop(m);
	for (i = 0; i < LENGTH(tags); i++) {
		w = TEXTW(m, tags[i]);
		drwl_setscheme(m->drw, colors[m->tagset[m->seltags] & 1 << i ? SchemeSel : SchemeNorm]);
		drwl_text(m->drw, x, 0, w, m->b.height, m->lrpad / 2, tags[i], urg & 1 << i);
		if (occ & 1 << i)
			drwl_rect(m->drw, x + boxs, boxs, boxw, boxw,
				m == selmon && c && c->tags & 1 << i,
				urg & 1 << i);
		x += w;
	}
	w = TEXTW(m, m->ltsymbol);
	drwl_setscheme(m->drw, colors[SchemeNorm]);
	x = drwl_text(m->drw, x, 0, w, m->b.height, m->lrpad / 2, m->ltsymbol, 0);

	if ((w = m->b.width - tw - x) > m->b.height) {
		if (c) {
			drwl_setscheme(m->drw, colors[m == selmon ? SchemeSel : SchemeNorm]);
			drwl_text(m->drw, x, 0, w, m->b.height, m->lrpad / 2, client_get_title(c), 0);
			if (c && c->isfloating)
				drwl_rect(m->drw, x + boxs, boxs, boxw, boxw, 0, 0);
		} else {
			drwl_setscheme(m->drw, colors[SchemeNorm]);
			drwl_rect(m->drw, x, 0, w, m->b.height, 1, 1);
		}
	}

	wlr_scene_buffer_set_dest_size(m->scene_buffer,
		m->b.real_width, m->b.real_height);
	wlr_scene_node_set_position(&m->scene_buffer->node, m->m.x,
		m->m.y + (topbar ? 0 : m->m.height - m->b.real_height));
	wlr_scene_buffer_set_buffer(m->scene_buffer, &buf->base);
	wlr_buffer_unlock(&buf->base);
}