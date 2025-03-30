web: bin/vite ssr & bin/rails server -p $PORT -e $RAILS_ENV
worker: bin/jobs start
release: bin/rails db:migrate