import spssaux
from extension import Template, Syntax, processcmd

def Run(args):
    oobj = Syntax([
        Template("B", subc="", ktype="int", var="b_n", islist = False),
        Template("OUTFILE", subc="OPTIONS", ktype="literal", var="b_file"),
        Template("SEED", subc="OPTIONS", ktype="int", var="seed"),
        Template("HELP", subc="", ktype="bool")
        ])
    args = args[list(args.keys())[0]]
    if "HELP" in args:
        helper()
    else:
        processcmd(oobj, args, gendata)

def sample_w_rep(n):
    import random
    x = random.sample(range(n * n), n)
    y = list(map(lambda j: j % n, x))
    return(y)

def sample_w_rep_n(b_n, n):
    out = [0] * (b_n * n)
    for i in range(b_n):
        k = i * n
        x = sample_w_rep(n)
        for j in x:
           out[k + j] += 1
    return(out)


def gendata(b_n,
             b_file = None,
             seed = None):
  
    import random
    import spss
    import os
    import SpssClient

    b_folder = None

    # TODO: Add sanity checks
    gbootdat_check(b_n, b_folder, seed)

    if isinstance(seed, int):
        random.seed(seed)

    name_old = spss.ActiveDataset()
    if name_old == "*":
        name_old = "bsourcedata"
        spss.Submit(r"""dataset name {name_old}.""".format(name_old = name_old))

    # Not yet find a way to get the data file path by the spss module.
    # Therefore, use SpssClient instead.
    SpssClient.StartClient()
    data_active = SpssClient.GetActiveDataDoc()
    data_path = data_active.GetDocumentPath()
    if not b_folder:
        b_folder =  os.path.dirname(data_path) + "\\"
    if not os.path.isdir(b_folder):
        os.makedirs(b_folder)

    spss.Submit(r"""
    compute boot_id = 0.
    loop boot_id = 1 to {b_n}.
    compute boot_case_id = $casenum.
    xsave outfile = '{b_folder}boot_samples_full.sav'
     /keep boot_id boot_case_id all
     /zcompressed.
    end loop.
    execute.
    """.format(b_n = b_n, b_folder = b_folder))

    spss.Submit(r"""
    get file = '{b_folder}boot_samples_full.sav'. 
    dataset name bfull.
    format boot_id (f10.0) boot_case_id (f10.0).
    sort cases by boot_id boot_case_id.
    execute.
    """.format(b_folder = b_folder))

    spss.StartDataStep()
    dataset_obj = spss.Dataset()
    n = len(dataset_obj.cases) // b_n
    dataset_obj.varlist.append('boot_freq')
    out = sample_w_rep_n(b_n, n)
    k = len(dataset_obj.varlist) - 1
    dataset_obj.cases[0:len(dataset_obj.cases), k] = out
    spss.EndDataStep()

    # Keep only sampled case.

    spss.Submit(r"""
    select if boot_freq > 0.
    execute.
    format boot_freq (f10.0).
    """.format(b_folder = b_folder))

    # Replicate cases.

    spss.Submit(r"""
    loop boot_case_id_i = 1 to boot_freq.
    xsave outfile = '{b_file}'
     /zcompressed
     /drop boot_freq
     /keep boot_id boot_case_id boot_case_id_i all.
    end loop.
    execute.
    dataset activate {name_old}.
    dataset close bfull.
    erase file = '{b_folder}boot_samples_full.sav'.
    """.format(b_folder = b_folder, name_old = name_old, b_file = b_file))

    spss.StartProcedure("GENERATE NONPAR BOOTSAMPLES")
    text_block = spss.TextBlock("Report", "Source data file: \n " + data_path)
    text_block.append("Data file with {n} cases in each copy: {b_file}".format(n = n, b_folder = b_folder, b_file = b_file))
    spss.EndProcedure()

    return(None)

def gbootdat_check(b_n,
                   b_folder,
                   seed):

    import spss

    # Check if the data file has some cases
    if spss.GetCaseCount() < 1:
        raise Exception("The active dataset is empty.") 

    # Check if split file is on
    if spss.GetSplitVariableNames():
        raise Exception("Split file is on in the active dataset. Split file is not supported. Please turn it off first.")     

    # Check if weighting is on
    if spss.GetWeightVar() is not None:
        raise Exception("Weighting is on in the active dataset. Weighting is not supported. Please turn it off first.")     

    # Check if b_n is a positive integer
    if not isinstance(b_n, int):
        raise Exception("b_n (the number of bootstrap sample) is not a positive integer greater than zero.")   
    if b_n < 1:
        raise Exception("b_n (the number of bootstrap sample) is not a positive integer greater than zero.") 

    return(0)

def gbootdat_test():

    print("test")

def helper():
    '''Adapted from Writing-IBM-SPSS-Statistics-Extension-Commands'''
    import webbrowser, os.path
    path = os.path.splittext(__file__)[0]
    helpfile = "file://" + path + os.path.sep + "markdown.html"
    browser = webbrowser.get()
    if not browser.open_new(helpfile):
        print("Help file not found:" + helpfile + ". Please visit the official GitHub page for information.")

try:
    from extension import helper
except:
    pass