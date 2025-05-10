package com.example

class ToolController {
    def springSecurityService
    def apiIntegrationService

    def index() {
        def tools = Tool.list()
        [tools: tools]
    }

    def create() {
        [tool: new Tool()]
    }

    def save(Tool tool) {
        if (tool.save()) {
            flash.message = "Herramienta creada exitosamente"
            redirect action: "show", id: tool.id
        } else {
            render view: "create", model: [tool: tool]
        }
    }

    def show(Long id) {
        def tool = Tool.get(id)
        if (!tool) {
            flash.message = "Herramienta no encontrada"
            redirect action: "index"
            return
        }

        def rentalLocations = []
        if (tool.availableForRent) {
            rentalLocations = apiIntegrationService.getToolRentalLocations(tool.name, "Madrid")
        }

        [tool: tool, rentalLocations: rentalLocations]
    }

    def edit(Long id) {
        def tool = Tool.get(id)
        if (!tool) {
            flash.message = "Herramienta no encontrada"
            redirect action: "index"
            return
        }
        [tool: tool]
    }

    def update(Tool tool) {
        if (tool.save()) {
            flash.message = "Herramienta actualizada exitosamente"
            redirect action: "show", id: tool.id
        } else {
            render view: "edit", model: [tool: tool]
        }
    }

    def delete(Long id) {
        def tool = Tool.get(id)
        if (tool) {
            tool.delete()
            flash.message = "Herramienta eliminada exitosamente"
        } else {
            flash.message = "Herramienta no encontrada"
        }
        redirect action: "index"
    }

    def search() {
        def query = params.query
        def tools = Tool.createCriteria().list {
            or {
                ilike('name', "%${query}%")
                ilike('category', "%${query}%")
                ilike('description', "%${query}%")
            }
        }
        render(view: "index", model: [tools: tools, query: query])
    }

    def toggleRentalStatus(Long id) {
        def tool = Tool.get(id)
        if (tool) {
            tool.availableForRent = !tool.availableForRent
            tool.save()
            flash.message = "Estado de alquiler actualizado"
        } else {
            flash.message = "Herramienta no encontrada"
        }
        redirect action: "show", id: id
    }
} 