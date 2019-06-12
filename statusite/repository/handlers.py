from django.conf import settings
from django.db.models.signals import pre_save
from django.dispatch import receiver
from github3 import login
from statusite.repository.models import Repository


@receiver(pre_save, sender=Repository)
def set_github_id(sender, **kwargs):
    repository = kwargs["instance"]

    if not repository.github_id:
        github = login(settings.GITHUB_USERNAME, settings.GITHUB_PASSWORD)
        repo = github.repository(repository.owner, repository.name)
        repository.github_id = repo.id
        repository.save()
