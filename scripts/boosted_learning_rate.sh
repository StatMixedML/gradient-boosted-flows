cd /export/scratch/robert/ensemble-normalizing-flows

# activate virtual environment
module unload soft/python
module load soft/python/anaconda
source /soft/python/anaconda/Linux_x86_64/etc/profile.d/conda.sh
conda activate env

# Load defaults for all experiments
source ./scripts/experiment_config.sh

# define variable specific to this experiment
experiment_name=learning_rate
num_components=2
annealing_schedule=100
epochs_per_component=200
epochs=450
vae_layers=linear
learning_rate=0.0005
regularization_rate=1.0

for learning_rate in 0.01 0.005 0.001 0.0005 0.0001
do
    python main_experiment.py --dataset mnist \
           --experiment_name ${experiment_name} \
           --validation \
           --no_cuda \
           --num_workers ${num_workers} \
           --no_lr_schedule \
           --rho_init decreasing \
           --learning_rate ${learning_rate} \
           --epochs ${epochs} \
           --annealing_schedule ${annealing_schedule} \
           --epochs_per_component ${epochs_per_component} \
           --vae_layers ${vae_layers} \
           --flow boosted \
           --component_type realnvp \
           --num_base_layers 1 \
           --base_network tanh \
           --h_size 128 \
           --num_components ${num_components} \
           --regularization_rate ${regularization_rate} \
           --num_flows 2 \
           --z_size ${z_size} \
           --batch_size ${batch_size} \
           --manual_seed ${manual_seed} \
           --plot_interval ${plotting} &
done
wait
echo "Job complete"
