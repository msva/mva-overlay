#!/usr/bin/env python
from __future__ import print_function
from setuptools import setup, find_packages
import platform

deps = ['yowsup', 'e4u']

setup(
    name='transwhat',
    version='2',
    url='http://github.com/stv0g/transwhat/',
    license='GPL-3+',
    author='Steffen Vogel',
    tests_require=[],
    install_requires = deps,
    #scripts = ['yowsup-cli'],
    #cmdclass={'test': PyTest},
    author_email='post@steffenvogel.de',
    description='A gateway between the XMPP (Jabber) and the WhatsApp network',
    #long_description=long_description,
    packages= find_packages(),
    include_package_data=True,
    platforms='any',
    #test_suite='',
    classifiers = [
        'Programming Language :: Python',
        'Development Status :: 4 - Beta',
        'Natural Language :: English',
        #'Environment :: Web Environment',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
        'Operating System :: OS Independent',
        'Topic :: Software Development :: Libraries :: Python Modules'
        ],
    #extras_require={
    #    'testing': ['pytest'],
    #}
)
