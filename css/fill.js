// Fills every element that has a `data-fill` attribute with that many
// `.block.child` items, labelled with `data-label` and a number. It keeps the
// HTML short. It has nothing to do with scrolling itself.
for (const list of document.querySelectorAll('[data-fill]')) {
  const label = list.dataset.label ?? '';
  for (let i = 1; i <= Number(list.dataset.fill); i++) {
    const item = document.createElement('div');
    item.className = 'block child';
    item.textContent = `${label}${i}`;
    list.append(item);
  }
}
