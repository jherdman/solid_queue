class CreateSolidQueueConcurrencyControls < ActiveRecord::Migration[7.1]
  def change
    change_table :solid_queue_jobs do |t|
      t.string :concurrency_key
    end

    create_table :solid_queue_blocked_executions do |t|
      t.references :job, index: { unique: true }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false

      t.string :concurrency_key, null: false

      t.datetime :created_at, null: false
      t.datetime :expires_at, null: false

      t.index [ :concurrency_key, :priority, :job_id ], name: "index_solid_queue_blocked_executions_for_release"
      t.index [ :expires_at, :concurrency_key ], name: "index_solid_queue_blocked_executions_for_maintenance"
    end

    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false, index: { unique: true }
      t.integer :value, null: false, default: 1
      t.datetime :expires_at, null: false, index: true

      t.timestamps

      t.index [ :key, :value ]
    end
  end
end