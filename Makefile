# Makefile for LTI ATS MVP (Elixir + Elm)

.PHONY: setup run test format reset-db frontend-backend

setup:
	cd LTI-GG/backend && mix deps.get && mix deps.compile
	cd LTI-GG/frontend && elm make src/Main.elm --output=dist/main.js || true

run:
	cd LTI-GG/backend && mix phx.server &
	cd LTI-GG/frontend && elm reactor &

format:
	cd LTI-GG/backend && mix format
	cd LTI-GG/frontend && elm-format src/ --yes

test:
	cd LTI-GG/backend && mix test --cover
	cd LTI-GG/frontend && elm-test

reset-db:
	cd LTI-GG/backend && iex -S mix run -e 'LtiGgBackend.Infrastructure.CandidateRepo.reset()'

frontend-backend:
	cd LTI-GG/backend && mix phx.server &
	cd LTI-GG/frontend && elm reactor &

# End of Makefile
