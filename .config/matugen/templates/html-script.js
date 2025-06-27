const colors = {
<* for name, value in colors *>
  "{{name}}" : "{{value.default.hex}}",
<* endfor *>
};

// Generate color palette in the DOM
const paletteContainer = document.getElementById('palette');

for (const [name, value] of Object.entries(colors)) {
    const div = document.createElement('div');
    div.className = 'color';
    div.innerHTML = `
        <div class="swatch" style="background-color: ${value};"></div>
        <div class="label">
            <div class="name">${name}</div>
            <div class="value">${value}</div>
        </div>
    `;
    paletteContainer.appendChild(div);
}
