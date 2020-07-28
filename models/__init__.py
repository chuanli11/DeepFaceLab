from .ModelBase import ModelBase

def import_model(model_class_name):
    module = __import__('Model_'+model_class_name, globals(), locals(), [], 1)
    return getattr(module, 'Model')

def import_model_tf1(model_class_name):
    module = __import__('Model_'+model_class_name, globals(), locals(), [], 1)
    return getattr(module, 'Model_tf1')

def import_model_tf1_multi(model_class_name):
    module = __import__('Model_'+model_class_name, globals(), locals(), [], 1)
    return getattr(module, 'Model_tf1_multi')

def import_model_tf1_nccl(model_class_name):
    module = __import__('Model_'+model_class_name, globals(), locals(), [], 1)
    return getattr(module, 'Model_tf1_nccl')
