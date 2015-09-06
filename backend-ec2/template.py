from jinja2 import Environment, FileSystemLoader, TemplateNotFound

class Template():

    def __init__(self, root):
        self.environment = Environment(loader=FileSystemLoader(root))

    def render(self, name, **kwargs):
        try:
            template = self.environment.get_template(name)
            content = template.render(kwargs)
            return content
        except TemplateNotFound:
            raise HTTPError(404, 'Template not found')