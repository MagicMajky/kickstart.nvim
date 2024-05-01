-- NOTE: plugins can also be added by using a table,
-- with the first argument being the link and the following
-- keys can be used to configure plugin behavior/loading/etc.
--
-- use `opts = {}` to force a plugin to be loaded.
--
--  this is equivalent to:
--    require('comment').setup({})

-- "gc" to comment visual regions/lines
return { 'numtostr/comment.nvim', opts = {} }
