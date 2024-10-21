function codify() {
  $(".flyout .ctx-menu-item:last").click()
  setTimeout(() => $(".flyout .bc-gray").click(), 100)
}

document.addEventListener("keydown", e => {
  if (e.key === 'c' && e.shiftKey && e.metaKey) {
    codify()
  }
})
