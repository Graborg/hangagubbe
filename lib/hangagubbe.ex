defmodule Hangagubbe do
  def create_game do
    clear_input()
    secret_word = ask_for_secret_word()
    clear_input()

    secret_word_length = String.length(secret_word)
    start_string = create_start_string(secret_word_length)

    guess(start_string, secret_word, "")
    ""
  end

  def guess(progress, secret_word, errors) do
    guessed_letter = next_guess_dialogue(progress, errors)

    new_progress = match_letter_with_secret_word(guessed_letter, secret_word, progress)

    new_errors = if new_progress == progress, do: errors <> " " <> guessed_letter, else: errors

    cond do
      word_completed?(new_progress, secret_word) ->
        clear_input()
        IO.puts("Hurray! '" <> secret_word <> "' is correct!")

      String.length(new_errors) > 4 ->
        clear_input()
        IO.puts("You lose")

      true ->
        guess(new_progress, secret_word, new_errors)
    end
  end

  def next_guess_dialogue(progress, errors) do
    clear_input()
    IO.puts("current progress: " <> progress)
    IO.puts("errors: " <> errors)

    IO.gets("\nGuess a letter!!\n")
    |> String.trim()
  end

  #### Private methods

  defp create_start_string(length), do: String.duplicate("_ ", length) |> String.trim()

  defp ask_for_secret_word() do
    IO.gets("What's the secret word?\n")
    |> String.trim()
  end

  defp word_completed?(guess, secret_word) do
    String.split(guess)
    |> Enum.join()
    |> Kernel.==(secret_word)
  end

  defp match_letter_with_secret_word(letter, secret_word, current_state) do
    find_indices(secret_word, letter)
    |> Enum.reduce(String.split(current_state), fn i, state ->
      List.replace_at(state, i, letter)
    end)
    |> Enum.join(" ")
  end

  defp clear_input() do
    IO.puts("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  end

  defp find_indices(secret_word, letter),
    do:
      String.split(secret_word, "", trim: true)
      |> Enum.with_index()
      |> Enum.filter(fn {x, _} -> letter == x end)
      |> Enum.map(fn {_, i} -> i end)
end
