local present, feline = pcall(require, 'bufferline')

if not present then
  return
end

require("bufferline").setup{
  options = {
    buffer_close_icon = 'x',
  }
}
