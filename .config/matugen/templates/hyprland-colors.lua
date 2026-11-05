-- Сгенерировано matugen — не редактировать вручную
return {
<* for name, value in colors *>
    {{name}} = "rgb({{value.default.hex_stripped}})",
<* endfor *>
<* for name, value in colors *>
    {{name}}_a = "rgba({{value.default.hex_stripped}}cc)",
<* endfor *>
}
