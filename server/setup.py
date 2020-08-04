from setuptools import setup

setup(name='mpvserver',
      version='0.1',
      description='mpv-controller server',
      long_description=open('..\README.md').read(),
      long_description_content_type="text/markdown",
      project_urls={
            "Source Code": "https://github.com/yesmey/mpv-controller",
      },
	  license = "Apache-2.0",
      author='',
      author_email='',
      packages=['mpvserver'],
      python_requires='>=3.8',
      install_requires=['python-mpv']
     )
