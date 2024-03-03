-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        'alanfortlink/blackjack.nvim',
        cmd = "BlackJackNewGame",
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { scores_path = vim.fn.getenv('XDG_CACHE_HOME') .. '/blackjack_scores.json' }
    }
}
