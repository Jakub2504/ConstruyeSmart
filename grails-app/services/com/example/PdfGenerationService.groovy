package com.example

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.xhtmlrenderer.pdf.ITextRenderer
import grails.gsp.PageRenderer

@Service
class PdfService {
    
    @Autowired
    PageRenderer groovyPageRenderer
    
    /**
     * Genera un PDF basado en una plantilla GSP
     * @param template La ruta a la plantilla GSP (sin el guión bajo inicial)
     * @param model El modelo para renderizar la plantilla
     * @return byte[] datos del PDF generado
     */
    byte[] generatePdf(String template, Map model) {
        // Renderizar la plantilla GSP a HTML
        String html = groovyPageRenderer.render(template: template, model: model)
        
        // Convertir HTML a PDF
        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        
        try {
            ITextRenderer renderer = new ITextRenderer()
            renderer.setDocumentFromString(html)
            renderer.layout()
            renderer.createPDF(baos)
        } catch (Exception e) {
            e.printStackTrace()
        }
        
        return baos.toByteArray()
    }
}