import random

from . import calculate_dimensions


# Create loader for stable diffusion scribble workflow
def build_workflow_loader(
    sd_checkpoint_name,
    negative_prompt,
    max_size,
    sampler_steps,
    sampler_cfg,
    sampler_algorithm="euler",
    sampler_scheduler="normal",
    sampler_denoise=1,
    controlnet_name="",
    controlnet_strength=0.8,
):

    # Loader for stable diffusion scribble workflow
    def load(params):
        job_id = params["job_id"]
        aspect_ratio = params["aspect_ratio"]
        positive_prompt = params["positive_prompt"]
        filename_prefix = params["filename_prefix"]
        input_filename = params["input_filename"]

        filename_prefix = f"{filename_prefix}_{job_id}"

        random_seed = random.randint(10**14, 10**15 - 1)

        image_width, image_height = calculate_dimensions(max_size, aspect_ratio)

        workflow_data = {
            "3": {
                "inputs": {
                    "seed": random_seed,
                    "steps": sampler_steps,
                    "cfg": sampler_cfg,
                    "sampler_name": sampler_algorithm,
                    "scheduler": sampler_scheduler,
                    "denoise": sampler_denoise,
                    "model": ["14", 0],
                    "positive": ["10", 0],
                    "negative": ["7", 0],
                    "latent_image": ["5", 0],
                },
                "class_type": "KSampler",
            },
            "5": {
                "inputs": {
                    "width": image_width,
                    "height": image_height,
                    "batch_size": 1,
                },
                "class_type": "EmptyLatentImage",
            },
            "6": {
                "inputs": {"text": positive_prompt, "clip": ["14", 1]},
                "class_type": "CLIPTextEncode",
            },
            "7": {
                "inputs": {"text": negative_prompt, "clip": ["14", 1]},
                "class_type": "CLIPTextEncode",
            },
            "8": {
                "inputs": {"samples": ["3", 0], "vae": ["14", 2]},
                "class_type": "VAEDecode",
            },
            "9": {
                "inputs": {"filename_prefix": filename_prefix, "images": ["8", 0]},
                "class_type": "SaveImage",
            },
            "10": {
                "inputs": {
                    "strength": controlnet_strength,
                    "conditioning": ["6", 0],
                    "control_net": ["12", 0],
                    "image": ["11", 0],
                },
                "class_type": "ControlNetApply",
            },
            "11": {
                "inputs": {"image": input_filename, "upload": "image"},
                "class_type": "LoadImage",
            },
            "12": {
                "inputs": {"control_net_name": controlnet_name},
                "class_type": "ControlNetLoader",
            },
            # "14": {
            #     "inputs": {"ckpt_name": sd_checkpoint_name},
            #     "class_type": "CheckpointLoaderSimple",
            # },
            "14": {
                "inputs": {
                    "ckpt_name": sd_checkpoint_name,
                    "key_opt": "",
                    "mode": "Auto",
                },
                "class_type": "CheckpointLoaderSimpleShared //Inspire",
            },
        }

        return workflow_data

    return load
